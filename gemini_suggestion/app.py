#!/usr/bin/env python3
import os
import sys
import json
import urllib.parse
from http.server import HTTPServer, BaseHTTPRequestHandler
from io import BytesIO

# Import the generation engine
from generator import GenerationEngine, log

PORT = 8000
config_file = "config.json"

# In-memory log buffer to capture output for the dashboard
log_buffer = []

def add_log(msg, level="INFO"):
    log_buffer.append(f"[{level}] {msg}")
    if len(log_buffer) > 200:
        log_buffer.pop(0)
    log(msg, level)

class DashboardHandler(BaseHTTPRequestHandler):
    def log_message(self, format, *args):
        # Suppress default server log spam on console to keep clean dashboard logs
        pass

    def do_GET(self):
        url_parsed = urllib.parse.urlparse(self.path)
        path = url_parsed.path

        if path == "/" or path == "/index.html":
            self.serve_dashboard()
        elif path == "/api/status":
            self.get_status()
        elif path == "/api/config":
            self.get_config()
        elif path == "/api/logs":
            self.get_logs()
        elif path == "/api/preview":
            self.get_preview(url_parsed.query)
        else:
            self.send_error(404, "File not found")

    def do_POST(self):
        url_parsed = urllib.parse.urlparse(self.path)
        path = url_parsed.path

        content_length = int(self.headers.get('Content-Length', 0))
        post_data = self.rfile.read(content_length) if content_length > 0 else b""

        if path == "/api/run_generate":
            self.run_generate(post_data)
        elif path == "/api/run_rsync":
            self.run_rsync(post_data)
        elif path == "/api/save_config":
            self.save_config(post_data)
        else:
            self.send_error(404, "Route not found")

    def send_json(self, data, status=200):
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()
        self.wfile.write(json.dumps(data).encode('utf-8'))

    def get_status(self):
        try:
            engine = GenerationEngine(config_path=config_file)
            mount_status = {}
            # Unique list of mounts to check
            unique_mounts = set()
            for p in engine.config.get("pages", []):
                for m in p.get("rsync", {}).get("mounts_required", []):
                    unique_mounts.add(m)
            
            for m in unique_mounts:
                mount_status[m] = engine.check_mount(m)

            response = {
                "workspace_root": engine.workspace_root,
                "config_loaded": True,
                "pages_count": len(engine.config.get("pages", [])),
                "mounts": mount_status
            }
            self.send_json(response)
        except Exception as e:
            self.send_json({"error": str(e)}, 500)

    def get_config(self):
        try:
            with open(config_file, "r") as f:
                config_data = json.load(f)
            self.send_json(config_data)
        except Exception as e:
            self.send_json({"error": str(e)}, 500)

    def get_logs(self):
        self.send_json({"logs": log_buffer})

    def run_generate(self, post_data):
        try:
            payload = json.loads(post_data.decode('utf-8'))
            page_id = payload.get("id")
            
            engine = GenerationEngine(config_path=config_file)
            add_log(f"Received dashboard request to generate page: {page_id}", "INFO")
            
            # Monkeypatch engine's log to capture into our buffer
            global log_buffer
            original_log = engine.generate_page if page_id != "all" else engine.generate_all_pages
            
            success = False
            if page_id == "all":
                engine.generate_all_pages()
                success = True
            else:
                success = engine.generate_page(page_id)

            if success:
                add_log(f"Page generation completed successfully for '{page_id}'", "SUCCESS")
                self.send_json({"status": "success", "message": "Generation completed successfully"})
            else:
                add_log(f"Page generation failed or skipped for '{page_id}'", "ERROR")
                self.send_json({"status": "failed", "message": "Generation failed"}, 400)
        except Exception as e:
            add_log(f"Error during page generation: {e}", "ERROR")
            self.send_json({"error": str(e)}, 500)

    def run_rsync(self, post_data):
        try:
            payload = json.loads(post_data.decode('utf-8'))
            page_id = payload.get("id")
            
            engine = GenerationEngine(config_path=config_file)
            add_log(f"Received dashboard request to run rsync for: {page_id}", "INFO")

            # Find page config
            page_config = None
            for p in engine.config.get("pages", []):
                if p["id"] == page_id:
                    page_config = p
                    break

            if not page_config:
                add_log(f"Page ID '{page_id}' not found for rsync.", "ERROR")
                self.send_json({"status": "failed", "message": "Page not found"}, 404)
                return

            if "rsync" not in page_config:
                add_log(f"Rsync not configured for page: {page_id}", "WARNING")
                self.send_json({"status": "skipped", "message": "Rsync not configured for this page"})
                return

            success = engine.run_rsync(page_config)
            if success:
                add_log(f"Rsync completed successfully for '{page_id}'", "SUCCESS")
                self.send_json({"status": "success", "message": "Rsync completed successfully"})
            else:
                add_log(f"Rsync failed for '{page_id}'", "ERROR")
                self.send_json({"status": "failed", "message": "Rsync failed"}, 400)
        except Exception as e:
            add_log(f"Error during rsync: {e}", "ERROR")
            self.send_json({"error": str(e)}, 500)

    def save_config(self, post_data):
        try:
            payload = json.loads(post_data.decode('utf-8'))
            with open(config_file, "w") as f:
                json.dump(payload, f, indent=2)
            add_log("Configuration file updated from dashboard.", "SUCCESS")
            self.send_json({"status": "success", "message": "Config saved successfully"})
        except Exception as e:
            add_log(f"Failed to save configuration: {e}", "ERROR")
            self.send_json({"error": str(e)}, 500)

    def get_preview(self, query_str):
        params = urllib.parse.parse_qs(query_str)
        page_id = params.get("id", [None])[0]
        
        if not page_id:
            self.send_error(400, "Missing Page ID")
            return

        try:
            engine = GenerationEngine(config_path=config_file)
            page_config = None
            for p in engine.config.get("pages", []):
                if p["id"] == page_id:
                    page_config = p
                    break

            if not page_config:
                self.send_error(404, "Page not found")
                return

            deploy_target = engine.get_absolute_path(page_config.get("html", {}).get("deploy_target"))
            if os.path.exists(deploy_target):
                self.send_response(200)
                self.send_header("Content-Type", "text/html")
                self.end_headers()
                with open(deploy_target, "rb") as f:
                    self.wfile.write(f.read())
            else:
                # Serve placeholder
                self.send_response(200)
                self.send_header("Content-Type", "text/html")
                self.end_headers()
                html = f"""<!DOCTYPE html><html><head><style>
                    body {{ font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; text-align: center; padding: 50px; background: #f8fafc; color: #64748b; }}
                    .card {{ background: white; padding: 30px; border-radius: 8px; display: inline-block; box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1); }}
                    h3 {{ color: #1e293b; margin-top: 0; }}
                    button {{ background: #2563eb; color: white; border: none; padding: 10px 20px; border-radius: 4px; font-weight: 500; cursor: pointer; }}
                    button:hover {{ background: #1d4ed8; }}
                </style></head><body>
                    <div class="card">
                        <h3>No HTML Generated Yet</h3>
                        <p>The webpage for <strong>{page_config['title']}</strong> has not been generated or deployed to its target location:</p>
                        <p style="font-family: monospace; background: #f1f5f9; padding: 8px; border-radius: 4px; font-size: 13px;">{deploy_target}</p>
                        <p>Click "Run Sync & Generate" on the dashboard to build it first.</p>
                    </div>
                </body></html>"""
                self.wfile.write(html.encode('utf-8'))
        except Exception as e:
            self.send_error(500, str(e))

    def serve_dashboard(self):
        self.send_response(200)
        self.send_header("Content-Type", "text/html")
        self.end_headers()

        dashboard_html = """<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enterprise Web-Generator Master Control Panel</title>
    <style>
        :root {
            --primary: #2563eb;
            --primary-hover: #1d4ed8;
            --bg-main: #f8fafc;
            --bg-card: #ffffff;
            --text-dark: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background-color: var(--bg-main);
            color: var(--text-dark);
            margin: 0;
            padding: 0;
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        /* Sidebar styling */
        .sidebar {
            width: 260px;
            background-color: #0f172a;
            color: white;
            display: flex;
            flex-direction: column;
            padding: 24px;
            box-sizing: border-box;
        }

        .sidebar h2 {
            font-size: 20px;
            margin: 0 0 32px 0;
            font-weight: 700;
            letter-spacing: -0.5px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .sidebar .badge-client {
            background: #1e293b;
            border: 1px solid #334155;
            color: #94a3b8;
            font-size: 11px;
            padding: 2px 6px;
            border-radius: 4px;
            margin-top: 4px;
            display: inline-block;
        }

        .sidebar-menu {
            list-style: none;
            padding: 0;
            margin: 0;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .sidebar-menu li a {
            color: #94a3b8;
            text-decoration: none;
            padding: 12px 16px;
            border-radius: 8px;
            display: block;
            font-weight: 500;
            transition: all 0.2s;
        }

        .sidebar-menu li a:hover, .sidebar-menu li.active a {
            color: white;
            background-color: #1e293b;
        }

        .sidebar-footer {
            margin-top: auto;
            font-size: 12px;
            color: #475569;
            border-top: 1px solid #1e293b;
            padding-top: 16px;
        }

        /* Main Content */
        .main-container {
            flex: 1;
            display: flex;
            flex-direction: column;
            height: 100vh;
            overflow: hidden;
        }

        .header {
            background-color: var(--bg-card);
            border-bottom: 1px solid var(--border);
            padding: 18px 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .header h1 {
            font-size: 22px;
            margin: 0;
            font-weight: 600;
        }

        .content {
            padding: 32px;
            overflow-y: auto;
            flex: 1;
            box-sizing: border-box;
        }

        /* Metrics Grid */
        .metrics-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 32px;
        }

        .metric-card {
            background-color: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.05);
        }

        .metric-card h3 {
            margin: 0 0 8px 0;
            font-size: 14px;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .metric-card .value {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .metric-card .status {
            font-size: 12px;
            display: flex;
            align-items: center;
            gap: 6px;
            color: var(--text-muted);
        }

        .badge {
            display: inline-flex;
            align-items: center;
            padding: 2px 8px;
            font-size: 11px;
            font-weight: 600;
            border-radius: 9999px;
        }

        .badge-success { background-color: #d1fae5; color: #065f46; }
        .badge-danger { background-color: #fee2e2; color: #991b1b; }
        .badge-warning { background-color: #fef3c7; color: #92400e; }

        /* Pages List Table */
        .card {
            background-color: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 12px;
            box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.05);
            margin-bottom: 32px;
            overflow: hidden;
        }

        .card-header {
            padding: 20px 24px;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .card-header h2 {
            font-size: 16px;
            margin: 0;
            font-weight: 600;
        }

        .btn {
            background-color: var(--primary);
            color: white;
            border: none;
            padding: 8px 16px;
            font-size: 13px;
            font-weight: 500;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn:hover { background-color: var(--primary-hover); }
        .btn-secondary { background-color: #f1f5f9; color: var(--text-dark); border: 1px solid var(--border); }
        .btn-secondary:hover { background-color: #e2e8f0; }
        .btn-sm { padding: 4px 10px; font-size: 12px; border-radius: 4px; }
        .btn-danger { background-color: var(--danger); }
        .btn-danger:hover { background-color: #dc2626; }

        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        th {
            background-color: #f8fafc;
            color: var(--text-muted);
            font-weight: 600;
            font-size: 12px;
            padding: 14px 24px;
            border-bottom: 1px solid var(--border);
            text-transform: uppercase;
        }

        td {
            padding: 16px 24px;
            border-bottom: 1px solid var(--border);
            font-size: 14px;
        }

        tr:last-child td { border-bottom: none; }

        /* Logs Console */
        .console {
            background-color: #0f172a;
            color: #e2e8f0;
            font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
            padding: 20px;
            border-radius: 8px;
            height: 250px;
            overflow-y: auto;
            font-size: 13px;
            line-height: 1.5;
            border: 1px solid #1e293b;
        }

        .log-line { margin: 0 0 6px 0; }
        .log-SUCCESS { color: #4ade80; }
        .log-WARNING { color: #fbbf24; }
        .log-ERROR { color: #f87171; }
        .log-INFO { color: #38bdf8; }

        /* Configuration Modal/Form styling */
        .config-editor-pane {
            display: none;
            flex-direction: column;
            gap: 20px;
        }

        textarea.editor {
            width: 100%;
            height: 450px;
            font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
            padding: 16px;
            border: 1px solid var(--border);
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 14px;
            line-height: 1.5;
            background-color: #fafafa;
        }

        /* Preview Area */
        .preview-pane {
            display: none;
            flex-direction: column;
            height: calc(100vh - 120px);
        }

        iframe.preview-frame {
            flex: 1;
            border: 1px solid var(--border);
            border-radius: 8px;
            background: white;
            box-shadow: inset 0 2px 4px 0 rgb(0 0 0 / 0.05);
        }

        .preview-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 16px;
        }

        .loader {
            display: inline-block;
            width: 14px;
            height: 14px;
            border: 2px solid rgba(255,255,255,0.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin 1s ease-in-out infinite;
        }

        @keyframes spin { to { transform: rotate(360deg); } }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <h2>Web Dashboard</h2>
        <span class="badge-client" id="client-name">Enterprise Engine</span>
        <div style="margin-top: 32px;">
            <ul class="sidebar-menu">
                <li id="menu-dashboard" class="active"><a href="#" onclick="switchTab('dashboard')">Dashboard</a></li>
                <li id="menu-config"><a href="#" onclick="switchTab('config')">Master Config</a></li>
                <li id="menu-logs"><a href="#" onclick="switchTab('logs-tab')">System Logs</a></li>
            </ul>
        </div>
        <div class="sidebar-footer">
            v1.0.0 Stable<br>
            © July 2026.
        </div>
    </div>

    <!-- Main Container -->
    <div class="main-container">
        <!-- Header -->
        <div class="header">
            <div>
                <h1 id="page-title">Enterprise Web Control Panel</h1>
                <p id="sub-title" style="margin: 4px 0 0 0; color: var(--text-muted); font-size: 13px;">Manage, sync, and compile client document servers automatically</p>
            </div>
            <div>
                <button class="btn" id="generate-all-btn" onclick="runGenerate('all', this)">
                    Compile All Pages
                </button>
            </div>
        </div>

        <!-- Dashboard Content -->
        <div class="content" id="tab-dashboard">
            <!-- Metrics -->
            <div class="metrics-grid" id="metrics-container">
                <div class="metric-card">
                    <h3>Active Pages</h3>
                    <div class="value" id="stat-pages">0</div>
                    <div class="status">Configured in config.json</div>
                </div>
                <div class="metric-card">
                    <h3>Mount Point: WL-SL</h3>
                    <div class="value" id="stat-mount-wl"><span style="color: var(--danger)">checking...</span></div>
                    <div class="status" id="stat-mount-wl-text">Waiting...</div>
                </div>
                <div class="metric-card">
                    <h3>Mount Point: IMS</h3>
                    <div class="value" id="stat-mount-ims"><span style="color: var(--danger)">checking...</span></div>
                    <div class="status" id="stat-mount-ims-text">Waiting...</div>
                </div>
            </div>

            <!-- Page Management -->
            <div class="card">
                <div class="card-header">
                    <h2>Managed Pages</h2>
                    <span style="font-size: 13px; color: var(--text-muted);">Configure actions below</span>
                </div>
                <table id="pages-table">
                    <thead>
                        <tr>
                            <th>Page ID</th>
                            <th>Page Title</th>
                            <th>Rsync Setup</th>
                            <th>Deploy Target</th>
                            <th style="text-align: right; padding-right: 24px;">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="pages-table-body">
                        <tr><td colspan="5" style="text-align: center; color: var(--text-muted);">Loading pages list...</td></tr>
                    </tbody>
                </table>
            </div>

            <!-- Live Logs Console -->
            <div class="card">
                <div class="card-header">
                    <h2>Process Monitor logs</h2>
                    <button class="btn btn-secondary btn-sm" onclick="clearLocalLogs()">Clear Window</button>
                </div>
                <div class="content" style="padding: 16px;">
                    <div class="console" id="console-logs">
                        <div class="log-line log-INFO">[SYSTEM] Dashboard console loaded. Waiting for logs...</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Master Config Tab -->
        <div class="content config-editor-pane" id="tab-config">
            <div class="card">
                <div class="card-header">
                    <h2>Master config.json</h2>
                    <div style="display: flex; gap: 8px;">
                        <button class="btn btn-secondary" onclick="loadConfigIntoEditor()">Reset Changes</button>
                        <button class="btn" onclick="saveConfigFromEditor(this)">Save Configurations</button>
                    </div>
                </div>
                <div style="padding: 24px;">
                    <p style="margin: 0 0 16px 0; font-size: 14px; color: var(--text-muted);">This is the single source of truth configuration file. Adding a page here automatically generates widgets and pipelines on the dashboard.</p>
                    <textarea class="editor" id="config-raw-editor"></textarea>
                </div>
            </div>
        </div>

        <!-- System Logs Tab -->
        <div class="content" id="tab-logs-tab" style="display: none; height: calc(100vh - 100px); flex-direction: column;">
            <div class="card" style="flex: 1; display: flex; flex-direction: column; margin-bottom: 0;">
                <div class="card-header">
                    <h2>Extended System Logs</h2>
                    <button class="btn btn-secondary btn-sm" onclick="fetchSystemLogs()">Refresh</button>
                </div>
                <div style="flex: 1; padding: 24px; box-sizing: border-box; overflow-y: auto;">
                    <div class="console" id="extended-console-logs" style="height: 100%;"></div>
                </div>
            </div>
        </div>

        <!-- HTML Preview Tab -->
        <div class="content preview-pane" id="tab-preview">
            <div class="preview-header">
                <div>
                    <h2 id="preview-page-title" style="margin: 0; font-size: 18px;">Page Preview</h2>
                    <p id="preview-page-target" style="margin: 2px 0 0 0; font-size: 12px; color: var(--text-muted); font-family: monospace;"></p>
                </div>
                <div style="display: flex; gap: 8px;">
                    <button class="btn btn-secondary" onclick="switchTab('dashboard')">Back to Dashboard</button>
                    <button class="btn" id="preview-refresh-btn" onclick="refreshPreview()">Refresh Preview</button>
                </div>
            </div>
            <iframe class="preview-frame" id="preview-iframe"></iframe>
        </div>
    </div>

    <script>
        let currentTab = 'dashboard';
        let currentPreviewPageId = '';

        function switchTab(tabId) {
            // Hide all tabs
            document.getElementById('tab-dashboard').style.display = tabId === 'dashboard' ? 'block' : 'none';
            document.getElementById('tab-config').style.display = tabId === 'config' ? 'flex' : 'none';
            document.getElementById('tab-logs-tab').style.display = tabId === 'logs-tab' ? 'flex' : 'none';
            document.getElementById('tab-preview').style.display = tabId === 'preview' ? 'flex' : 'none';

            // Active menu state
            document.getElementById('menu-dashboard').className = tabId === 'dashboard' ? 'active' : '';
            document.getElementById('menu-config').className = tabId === 'config' ? 'active' : '';
            document.getElementById('menu-logs').className = tabId === 'logs-tab' ? 'active' : '';

            // Set title
            if (tabId === 'dashboard') {
                document.getElementById('page-title').innerText = "Enterprise Web-Generator Master Control Panel";
                document.getElementById('sub-title').innerText = "Manage, sync, and compile client document servers automatically";
            } else if (tabId === 'config') {
                document.getElementById('page-title').innerText = "Configuration Management";
                document.getElementById('sub-title').innerText = "Manage clients, folders, columns and templates dynamically";
            } else if (tabId === 'logs-tab') {
                document.getElementById('page-title').innerText = "Extended Process Monitor Logs";
                document.getElementById('sub-title').innerText = "Complete output log trail of all executed tasks";
            }

            currentTab = tabId;
        }

        // Fetch Dashboard Stats and Mount Point Status
        async function fetchStatus() {
            try {
                const res = await fetch('/api/status');
                const data = await res.json();
                if (data.error) throw new Error(data.error);

                document.getElementById('stat-pages').innerText = data.pages_count;

                // Check Mounts
                const wl_mounted = data.mounts['/Volumes/WL-SL'];
                const ims_mounted = data.mounts['/Volumes/IMS'];

                updateMountElement('stat-mount-wl', 'stat-mount-wl-text', wl_mounted, '/Volumes/WL-SL');
                updateMountElement('stat-mount-ims', 'stat-mount-ims-text', ims_mounted, '/Volumes/IMS');

            } catch (err) {
                console.error("Failed to fetch status:", err);
            }
        }

        function updateMountElement(valId, textId, isMounted, label) {
            const valEl = document.getElementById(valId);
            const textEl = document.getElementById(textId);
            if (isMounted) {
                valEl.innerHTML = '<span style="color: var(--success)">ACTIVE</span>';
                textEl.innerHTML = label + ' available';
            } else {
                valEl.innerHTML = '<span style="color: var(--danger)">OFFLINE</span>';
                textEl.innerHTML = label + ' unmounted';
            }
        }

        // Load managed pages list
        async function fetchPages() {
            try {
                const res = await fetch('/api/config');
                const config = await res.json();
                
                const workspace = config.settings.workspace_root || '';
                const pages = config.pages || [];
                const tbody = document.getElementById('pages-table-body');
                tbody.innerHTML = '';

                pages.forEach(p => {
                    const rsync_info = p.rsync ? 
                        `<span style="font-size:12px; font-weight:500;">✓ Configured</span><br><small style="color:var(--text-muted); font-size:11px;">Source: ${p.rsync.source}</small>` : 
                        '<span style="color:var(--text-muted)">No Sync needed</span>';

                    const row = document.createElement('tr');
                    row.innerHTML = `
                        <td style="font-family:monospace; font-weight:600; color:var(--primary);">${p.id}</td>
                        <td>
                            <strong>${p.title}</strong><br>
                            <small style="color:var(--text-muted); font-size:11px;">Parser: ${p.parser.type}</small>
                        </td>
                        <td>${rsync_info}</td>
                        <td style="font-size:12px; font-family:monospace; color:var(--text-muted);">${p.html.deploy_target}</td>
                        <td style="text-align: right; padding-right: 24px;">
                            <div style="display: flex; gap: 8px; justify-content: flex-end;">
                                ${p.rsync ? `<button class="btn btn-secondary btn-sm" onclick="runRsync('${p.id}', this)">Rsync Only</button>` : ''}
                                <button class="btn btn-secondary btn-sm" onclick="previewPage('${p.id}', '${p.title}', '${p.html.deploy_target}')">Preview</button>
                                <button class="btn btn-sm" onclick="runGenerate('${p.id}', this)">Run & Deploy</button>
                            </div>
                        </td>
                    `;
                    tbody.appendChild(row);
                });

            } catch (err) {
                console.error("Failed to fetch pages:", err);
            }
        }

        // Run Page Sync & HTML Generation
        async function runGenerate(pageId, btnEl) {
            const originalText = btnEl.innerHTML;
            btnEl.disabled = true;
            btnEl.innerHTML = '<span class="loader"></span> Processing...';

            try {
                const res = await fetch('/api/run_generate', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({id: pageId})
                });
                const data = await res.json();
                
                if (res.status === 200) {
                    btnEl.style.backgroundColor = 'var(--success)';
                    setTimeout(() => { btnEl.style.backgroundColor = ''; btnEl.innerHTML = originalText; btnEl.disabled = false; }, 2000);
                } else {
                    btnEl.style.backgroundColor = 'var(--danger)';
                    setTimeout(() => { btnEl.style.backgroundColor = ''; btnEl.innerHTML = originalText; btnEl.disabled = false; }, 3000);
                }
            } catch (err) {
                btnEl.style.backgroundColor = 'var(--danger)';
                setTimeout(() => { btnEl.style.backgroundColor = ''; btnEl.innerHTML = originalText; btnEl.disabled = false; }, 3000);
            }
            fetchSystemLogs();
            fetchStatus();
        }

        // Run Rsync only
        async function runRsync(pageId, btnEl) {
            const originalText = btnEl.innerHTML;
            btnEl.disabled = true;
            btnEl.innerHTML = '<span class="loader"></span> Syncing...';

            try {
                const res = await fetch('/api/run_rsync', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({id: pageId})
                });
                const data = await res.json();
                
                if (res.status === 200) {
                    btnEl.style.backgroundColor = 'var(--success)';
                    setTimeout(() => { btnEl.style.backgroundColor = ''; btnEl.innerHTML = originalText; btnEl.disabled = false; }, 2000);
                } else {
                    btnEl.style.backgroundColor = 'var(--danger)';
                    setTimeout(() => { btnEl.style.backgroundColor = ''; btnEl.innerHTML = originalText; btnEl.disabled = false; }, 3000);
                }
            } catch (err) {
                btnEl.style.backgroundColor = 'var(--danger)';
                setTimeout(() => { btnEl.style.backgroundColor = ''; btnEl.innerHTML = originalText; btnEl.disabled = false; }, 3000);
            }
            fetchSystemLogs();
            fetchStatus();
        }

        // Fetch Logs live
        async function fetchSystemLogs() {
            try {
                const res = await fetch('/api/logs');
                const data = await res.json();
                
                const consoleDiv = document.getElementById('console-logs');
                const extendedConsoleDiv = document.getElementById('extended-console-logs');

                let html = '';
                data.logs.forEach(line => {
                    let cls = 'log-INFO';
                    if (line.includes('[SUCCESS]')) cls = 'log-SUCCESS';
                    else if (line.includes('[WARNING]')) cls = 'log-WARNING';
                    else if (line.includes('[ERROR]')) cls = 'log-ERROR';
                    
                    html += `<div class="log-line ${cls}">${escapeHtml(line)}</div>`;
                });

                consoleDiv.innerHTML = html || '<div class="log-line log-INFO">Console empty. Actions will be logged here.</div>';
                extendedConsoleDiv.innerHTML = html || '<div class="log-line log-INFO">Console empty. Actions will be logged here.</div>';
                
                // Auto scroll
                consoleDiv.scrollTop = consoleDiv.scrollHeight;
                extendedConsoleDiv.scrollTop = extendedConsoleDiv.scrollHeight;

            } catch (err) {
                console.error("Failed to fetch logs:", err);
            }
        }

        function escapeHtml(text) {
            return text
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/"/g, "&quot;")
                .replace(/'/g, "&#039;");
        }

        function clearLocalLogs() {
            document.getElementById('console-logs').innerHTML = '<div class="log-line log-INFO">[CONSOLE] Cleared. Logs will continue to arrive on next actions.</div>';
        }

        // Preview Deployed Page in Dashboard
        function previewPage(pageId, title, deployTarget) {
            currentPreviewPageId = pageId;
            document.getElementById('preview-page-title').innerText = "Webpage Preview: " + title;
            document.getElementById('preview-page-target').innerText = "Deploy target: " + deployTarget;
            document.getElementById('preview-iframe').src = '/api/preview?id=' + pageId + '&t=' + Date.now();
            switchTab('preview');
        }

        function refreshPreview() {
            if (currentPreviewPageId) {
                document.getElementById('preview-iframe').src = '/api/preview?id=' + currentPreviewPageId + '&t=' + Date.now();
            }
        }

        // Config raw editor
        async function loadConfigIntoEditor() {
            try {
                const res = await fetch('/api/config');
                const config = await res.json();
                document.getElementById('config-raw-editor').value = JSON.stringify(config, null, 2);
            } catch (err) {
                alert("Failed to load configuration file.");
            }
        }

        async function saveConfigFromEditor(btnEl) {
            const rawText = document.getElementById('config-raw-editor').value;
            let parsed;
            try {
                parsed = JSON.parse(rawText);
            } catch (err) {
                alert("Invalid JSON format! Please check commas, quotes, and braces before saving.");
                return;
            }

            btnEl.disabled = true;
            btnEl.innerText = "Saving...";

            try {
                const res = await fetch('/api/save_config', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify(parsed)
                });
                if (res.status === 200) {
                    alert("Configuration saved successfully!");
                    fetchPages();
                    fetchStatus();
                } else {
                    alert("Failed to save configuration.");
                }
            } catch (err) {
                alert("Server error occurred while saving configuration.");
            }
            btnEl.disabled = false;
            btnEl.innerText = "Save Configurations";
        }

        // Initialize Page
        async function init() {
            await fetchStatus();
            await fetchPages();
            await fetchSystemLogs();
            await loadConfigIntoEditor();

            // Auto refresh status and logs periodically
            setInterval(fetchStatus, 15000);
            setInterval(fetchSystemLogs, 3000);
        }

        window.onload = init;
    </script>
</body>
</html>
"""
        self.wfile.write(dashboard_html.encode('utf-8'))

def run_server():
    server_address = ('', PORT)
    httpd = HTTPServer(server_address, DashboardHandler)
    log(f"===========================================================", "SUCCESS")
    log(f"   ENTERPRISE WEB CONTROL PANEL RUNNING AT:", "SUCCESS")
    log(f"   👉 http://localhost:{PORT}/ 👈", "SUCCESS")
    log(f"   Press Ctrl+C to terminate.", "WARNING")
    log(f"===========================================================", "SUCCESS")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        log("\nShutting down server gracefully.", "INFO")
        sys.exit(0)

if __name__ == "__main__":
    # Create config file if not exists
    if not os.path.exists(config_file):
        log(f"No config.json found. Please copy one before starting.", "ERROR")
        sys.exit(1)
    run_server()
