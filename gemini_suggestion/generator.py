#!/usr/bin/env python3
import os
import sys
import re
import json
import shutil
import datetime
import subprocess
import sqlite3

def log(msg, level="INFO"):
    colors = {
        "INFO": "\033[94m",    # Blue
        "SUCCESS": "\033[92m", # Green
        "WARNING": "\033[93m", # Yellow
        "ERROR": "\033[91m",   # Red
        "RESET": "\033[0m"
    }
    color = colors.get(level, colors["INFO"])
    print(f"{color}[{level}] {msg}{colors['RESET']}")

class GenerationEngine:
    def __init__(self, config_path="config.json"):
        self.config_path = config_path
        self.load_config()

    def load_config(self):
        with open(self.config_path, "r") as f:
            self.config = json.load(f)
        self.settings = self.config.get("settings", {})
        self.workspace_root = self.settings.get("workspace_root", os.getcwd())

    def get_absolute_path(self, path):
        if not path:
            return ""
        if os.path.isabs(path):
            return path
        return os.path.abspath(os.path.join(self.workspace_root, path))

    def check_mount(self, mount_path):
        """Checks if a mount path exists and is accessible."""
        abs_mount = self.get_absolute_path(mount_path)
        if not os.path.exists(abs_mount):
            return False
        # Sometimes a mount point directory exists but is empty/unmounted.
        # We can try to list its contents to verify.
        try:
            os.listdir(abs_mount)
            return True
        except Exception:
            return False

    def run_rsync(self, page_config):
        rsync_cfg = page_config.get("rsync")
        if not rsync_cfg:
            return True

        source = rsync_cfg.get("source")
        target = rsync_cfg.get("target")
        mounts = rsync_cfg.get("mounts_required", [])

        # Validate mounts
        for m in mounts:
            if not self.check_mount(m):
                log(f"Required mount not available: {m}", "ERROR")
                return False

        # Run Rsync
        log(f"Starting rsync from '{source}' to '{target}'...", "INFO")
        cmd = ["rsync", "-azr", "--delete", source, target]
        try:
            subprocess.run(cmd, check=True)
            log(f"Rsync completed successfully for {page_config['title']}.", "SUCCESS")
            return True
        except subprocess.CalledProcessError as e:
            log(f"Rsync failed with error: {e}", "ERROR")
            return False

    def scan_files(self, scanner_cfg):
        if not scanner_cfg:
            return []

        search_dir = self.get_absolute_path(scanner_cfg.get("search_dir"))
        file_pattern = scanner_cfg.get("file_pattern", "*.pdf")
        exclude_keywords = scanner_cfg.get("exclude_keywords", [])
        file_must_contain = scanner_cfg.get("file_must_contain", "")

        # Convert simple glob patterns (like NE-QHSE*.pdf) to regex
        pattern_regex = file_pattern.replace(".", "\\.").replace("*", ".*")
        pattern_re = re.compile(f"^{pattern_regex}$", re.IGNORECASE)

        if not os.path.exists(search_dir):
            log(f"Search directory does not exist: {search_dir}", "WARNING")
            return []

        results = []
        for root, _, files in os.walk(search_dir):
            for file in files:
                if not pattern_re.match(file):
                    continue
                if file_must_contain and file_must_contain not in file:
                    continue
                
                # Check exclusions
                excluded = False
                for kw in exclude_keywords:
                    if kw in file:
                        excluded = True
                        break
                if excluded:
                    continue

                abs_path = os.path.abspath(os.path.join(root, file))
                file_name_no_ext = os.path.splitext(file)[0]
                results.append((file_name_no_ext, abs_path))

        log(f"Scanned {len(results)} files in {search_dir}.", "INFO")
        return results

    def process_regex_parser(self, page_config, files_data):
        parser_cfg = page_config.get("parser", {})
        columns = parser_cfg.get("columns", [])
        
        rows = ["<tbody>"]
        for idx, (name, path) in enumerate(files_data, 1):
            web_path = path.replace("/Volumes/WL-SL", "..")
            
            row_html = "  <tr>"
            for col in columns:
                col_type = col.get("type")
                if col_type == "index":
                    row_html += f'\n    <th scope="row">{idx}</th>'
                elif col_type == "name":
                    row_html += f'\n    <td>{name}</td>'
                elif col_type == "static":
                    val = col.get("value", "")
                    row_html += f'\n    <td>{val}</td>'
                elif col_type == "regex":
                    pattern = col.get("pattern", "")
                    match = re.search(pattern, name)
                    val = match.group(0) if match else ""
                    row_html += f'\n    <td>{val}</td>'
                elif col_type == "link":
                    row_html += f'\n    <td><a href="{web_path}" target="_blank">link</a></td>'
            row_html += "\n  </tr>"
            rows.append(row_html)
        
        rows.append("</tbody>")
        return "\n".join(rows)

    def process_date_expiration_parser(self, page_config, files_data):
        parser_cfg = page_config.get("parser", {})
        columns = parser_cfg.get("columns", [])
        
        today = datetime.datetime.now()
        next_month = today + datetime.timedelta(days=30)
        
        rows = ["<tbody>"]
        row_number = 1
        
        for name, path in files_data:
            # Extract date - standard in personnel name is an 8-digit string (e.g. 20261231)
            date_match = re.search(r"\d{8}", name)
            if not date_match:
                # Fallback to general 4-digit/date extracts or skip
                continue
                
            date_str = date_match.group(0)
            try:
                exp_date = datetime.datetime.strptime(date_str, "%Y%m%d")
            except ValueError:
                continue
                
            bg_class = ""
            if exp_date < today:
                bg_class = ' class="text-bg-danger"'
            elif exp_date <= next_month:
                bg_class = ' class="text-bg-warning"'
                
            web_path = path.replace("/Volumes/WL-SL", "..")
            
            # Extract standard words
            words = name.split()
            
            row_html = "  <tr>"
            for col in columns:
                col_type = col.get("type")
                if col_type == "index":
                    row_html += f'\n    <th scope="row">{row_number}</th>'
                elif col_type == "name_styled":
                    row_html += f'\n    <td{bg_class}>{name}</td>'
                elif col_type == "word":
                    w_idx = col.get("index", 0)
                    val = words[w_idx] if w_idx < len(words) else ""
                    row_html += f'\n    <td>{val}</td>'
                elif col_type == "date_extracted":
                    row_html += f'\n    <td>{exp_date.strftime("%Y-%m-%d")}</td>'
                elif col_type == "link":
                    row_html += f'\n    <td><a href="{web_path}" target="_blank">link</a></td>'
            row_html += "\n  </tr>"
            rows.append(row_html)
            row_number += 1
            
        rows.append("</tbody>")
        return "\n".join(rows)

    def process_coc_dictionary_parser(self, page_config, files_data):
        parser_cfg = page_config.get("parser", {})
        dict_source = self.get_absolute_path(parser_cfg.get("dictionary_source"))
        columns = parser_cfg.get("columns", [])
        
        sn_dict = {}
        if os.path.exists(dict_source):
            with open(dict_source, "r") as f:
                for line in f:
                    parts = line.strip().split(",", 1)
                    if len(parts) == 2:
                        key = parts[0].strip('" ')
                        val = parts[1].strip('" ')
                        sn_dict[key] = val
        else:
            log(f"COC dictionary source not found: {dict_source}", "WARNING")
            
        rows = ["<tbody>"]
        for idx, (name, path) in enumerate(files_data, 1):
            web_path = path.replace("/Volumes/WL-SL", "..")
            # Extract SN by trimming the last 4 characters as in original shell code (e.g. name length - 4)
            sn = name[:-4] if len(name) > 4 else name
            desc = sn_dict.get(name, "")
            
            row_html = "  <tr>"
            for col in columns:
                col_type = col.get("type")
                if col_type == "index":
                    row_html += f'\n    <th scope="row">{idx}</th>'
                elif col_type == "dictionary_desc":
                    row_html += f'\n    <td>{desc}</td>'
                elif col_type == "serial_number":
                    row_html += f'\n    <td>{sn}</td>'
                elif col_type == "static":
                    val = col.get("value", "")
                    row_html += f'\n    <td>{val}</td>'
                elif col_type == "link":
                    row_html += f'\n    <td><a href="{web_path}" target="_blank">link</a></td>'
            row_html += "\n  </tr>"
            rows.append(row_html)
            
        rows.append("</tbody>")
        return "\n".join(rows)

    def process_database_assets_parser(self, page_config):
        parser_cfg = page_config.get("parser", {})
        db_file = self.get_absolute_path(parser_cfg.get("db_path"))
        csv_file = self.get_absolute_path(parser_cfg.get("csv_fallback_path"))
        cert_list_path = self.get_absolute_path(parser_cfg.get("certificates_list_source"))
        coc_list_path = self.get_absolute_path(parser_cfg.get("coc_list_source"))
        
        # Load certificate paths
        certs = []
        if os.path.exists(cert_list_path):
            with open(cert_list_path, "r") as f:
                for line in f:
                    parts = line.strip().split(",", 1)
                    if len(parts) == 2:
                        certs.append((parts[0].strip('" '), parts[1].strip('" ')))
                        
        # Load coc paths
        cocs = []
        if os.path.exists(coc_list_path):
            with open(coc_list_path, "r") as f:
                for line in f:
                    parts = line.strip().split(",", 1)
                    if len(parts) == 2:
                        cocs.append((parts[0].strip('" '), parts[1].strip('" ')))
                        
        def find_link(pattern, sn, list_data):
            # equivalent to awk search: $0 ~ pattern sn
            for name, path in list_data:
                if pattern in name and sn in name:
                    return path.replace("/Volumes/WL-SL", "..")
            return ""

        def find_coc_link(sn, list_data):
            # equivalent to awk search: $1 ~ sn "ICC1"
            for name, path in list_data:
                if sn in name and "ICC1" in name:
                    return path.replace("/Volumes/WL-SL", "..")
            return ""

        rows = ["<tbody>"]
        row_number = 1
        
        # Load equipment data either from sqlite or exported csv
        equipment_rows = []
        if os.path.exists(db_file):
            try:
                conn = sqlite3.connect(db_file)
                cursor = conn.cursor()
                cursor.execute("SELECT id, sn, description, type, size, tag, manufacturer, bl, inOperation, category, isAsset, rating, comment FROM sl_equipment;")
                equipment_rows = cursor.fetchall()
                conn.close()
            except Exception as e:
                log(f"Database read failed: {e}. Trying CSV fallback.", "WARNING")
                
        if not equipment_rows and os.path.exists(csv_file):
            import csv
            try:
                with open(csv_file, "r") as f:
                    reader = csv.reader(f)
                    next(reader) # skip header
                    for r in reader:
                        # Map to matching lengths
                        if len(r) >= 13:
                            equipment_rows.append(r[:13])
            except Exception as e:
                log(f"CSV read failed: {e}", "ERROR")
                
        for eq in equipment_rows:
            # eq: [id, sn, description, type, size, tag, manufacturer, comment, bl, inOperation, category, isAsset, rating]
            # wait, original code mappings: id, sn, description, type, size, tag, manufacturer, comment, bl, inOperation, category, isAsset, rating
            # let's be flexible and extract by index safely
            sn = eq[1] if len(eq) > 1 else ""
            eq_type = eq[3] if len(eq) > 3 else ""
            desc = eq[2].replace('"', '') if len(eq) > 2 else ""
            size = eq[4] if len(eq) > 4 else ""
            tag = eq[5] if len(eq) > 5 else ""
            mfr = eq[6] if len(eq) > 6 else ""
            bl = eq[7] if len(eq) > 7 else ""
            cat = eq[10] if len(eq) > 10 else ""
            rating = eq[11] if len(eq) > 11 else ""
            comment = eq[12] if len(eq) > 12 else ""
            
            row_html = f"""  <tr>
    <th scope="row">{row_number}</th>
    <td>{sn}</td>
    <td>{eq_type}</td>
    <td>{desc}</td>
    <td>{size}</td>
    <td>{tag}</td>
    <td>{mfr}</td>
    <td>{bl}</td>
    <td>{cat}</td>
    <td>{rating}</td>
    <td>{comment}</td>"""
            
            # MPI
            mpi_link = find_link("MPI", sn, certs)
            if mpi_link:
                row_html += f"\n    <td class='bg-success text-center'> <a href=\"{mpi_link}\" target=\"_blank\" class=\"text-white fw-bold text-decoration-none\">MPI</a> </td>"
            else:
                row_html += "\n    <td class='bg-danger text-center'>NA</td>"
                
            # UTM
            utm_link = find_link("UTM", sn, certs)
            if utm_link:
                row_html += f"\n    <td class='bg-success text-center'> <a href=\"{utm_link}\" target=\"_blank\" class=\"text-white fw-bold text-decoration-none\">UTM</a> </td>"
            else:
                row_html += "\n    <td class='bg-danger text-center'>NA</td>"
                
            # PT
            pt_link = find_link("PT", sn, certs)
            if pt_link:
                row_html += f"\n    <td class='bg-success text-center'> <a href=\"{pt_link}\" target=\"_blank\" class=\"text-white fw-bold text-decoration-none\">PT</a> </td>"
            else:
                row_html += "\n    <td class='bg-danger text-center'>NA</td>"
                
            # Calib
            cal_link = find_link("Calib", sn, certs)
            if cal_link:
                row_html += f"\n    <td class='bg-success text-center'> <a href=\"{cal_link}\" target=\"_blank\" class=\"text-white fw-bold text-decoration-none\">Calib</a> </td>"
            else:
                row_html += "\n    <td class='bg-danger text-center'>NA</td>"
                
            # COC
            coc_link = find_coc_link(sn, cocs)
            if coc_link:
                row_html += f"\n    <td class='bg-success text-center'> <a href=\"{coc_link}\" target=\"_blank\" class=\"text-white fw-bold text-decoration-none\">COC</a> </td>"
            else:
                row_html += "\n    <td class='bg-danger text-center text-white'>NA</td>"
                
            row_html += "\n  </tr>"
            rows.append(row_html)
            row_number += 1
            
        rows.append("</tbody>")
        return "\n".join(rows)

    def process_database_personnel_parser(self, page_config):
        parser_cfg = page_config.get("parser", {})
        db_file = self.get_absolute_path(parser_cfg.get("db_path"))
        csv_file = self.get_absolute_path(parser_cfg.get("csv_fallback_path"))
        cert_list_path = self.get_absolute_path(parser_cfg.get("certificates_list_source"))
        
        # Load personnel certificate paths
        certs = []
        if os.path.exists(cert_list_path):
            with open(cert_list_path, "r") as f:
                for line in f:
                    parts = line.strip().split(",", 1)
                    if len(parts) == 2:
                        certs.append((parts[0].strip('" '), parts[1].strip('" ')))
                        
        def find_cert_link(cert_code, fullname, list_data):
            for name, path in list_data:
                if cert_code in name and fullname in name:
                    return path.replace("/Volumes/WL-SL", "..")
            return ""

        rows = ["<tbody>"]
        row_number = 1
        
        personnel_rows = []
        if os.path.exists(db_file):
            try:
                conn = sqlite3.connect(db_file)
                cursor = conn.cursor()
                cursor.execute("SELECT id, FullName, Grade, Position, DateOfJoin FROM personnel_sl;")
                personnel_rows = cursor.fetchall()
                conn.close()
            except Exception as e:
                log(f"Database read failed: {e}. Trying CSV fallback.", "WARNING")
                
        if not personnel_rows and os.path.exists(csv_file):
            import csv
            try:
                with open(csv_file, "r") as f:
                    reader = csv.reader(f)
                    next(reader) # skip header
                    for r in reader:
                        if len(r) >= 5:
                            personnel_rows.append(r[:5])
            except Exception as e:
                log(f"CSV read failed: {e}", "ERROR")
                
        for p in personnel_rows:
            fullname = p[1].strip('" ') if len(p) > 1 else ""
            if not fullname:
                continue
                
            row_html = f"""  <tr>
    <th scope="row">{row_number}</th>
    <td>{fullname}</td>"""
            
            # Certificate codes as in shell script
            cert_codes = [
                ("FF", "FF"),
                ("FA", "FA"),
                ("H2S", "H2S"),
                ("WAH", "WAH"),
                ("Lifting", "Lifting"),
                ("AGT", "AGT"),
                ("Banks", "Banksman"),
                ("Crane", "Crane-Op"),
                ("IWCF", "IWCF")
            ]
            
            for code, label in cert_codes:
                link = find_cert_link(code, fullname, certs)
                if link:
                    row_html += f"\n    <td class='{code.lower()} bg-success text-center'> <a href=\"{link}\" target=\"_blank\" class=\"text-white fw-bold text-decoration-none\">{label}</a> </td>"
                else:
                    row_html += f"\n    <td class='{code.lower()} bg-danger text-center'>NA</td>"
                    
            row_html += "\n  </tr>"
            rows.append(row_html)
            row_number += 1
            
        rows.append("</tbody>")
        return "\n".join(rows)

    def assemble_html(self, page_config, body_rows_html):
        html_cfg = page_config.get("html", {})
        header_path = self.get_absolute_path(html_cfg.get("header_template"))
        table_path = self.get_absolute_path(html_cfg.get("table_template"))
        
        nav_path = self.get_absolute_path(self.settings.get("shared_nav_template"))
        footer_path = self.get_absolute_path(self.settings.get("shared_footer_template"))
        
        # Read contents
        header_html = ""
        if os.path.exists(header_path):
            with open(header_path, "r") as f:
                header_html = f.read()
        else:
            header_html = f"<!DOCTYPE html><html><head><title>{page_config['title']}</title></head><body>"
            
        nav_html = ""
        if os.path.exists(nav_path):
            with open(nav_path, "r") as f:
                nav_html = f.read()
                
        table_html = ""
        if os.path.exists(table_path):
            with open(table_path, "r") as f:
                table_html = f.read()
                
        footer_html = ""
        if os.path.exists(footer_path):
            with open(footer_path, "r") as f:
                footer_html = f.read()
        else:
            footer_html = "</body></html>"
            
        # Compile everything
        full_html = f"{header_html}\n{nav_html}\n{table_html}\n{body_rows_html}\n{footer_html}"
        return full_html

    def generate_page(self, page_id):
        page_config = None
        for p in self.config.get("pages", []):
            if p["id"] == page_id:
                page_config = p
                break
                
        if not page_config:
            log(f"Page ID '{page_id}' not found in configuration.", "ERROR")
            return False
            
        log(f"Processing page: {page_config['title']} ({page_id})...", "INFO")
        
        # 1. Run Rsync
        if "rsync" in page_config:
            success = self.run_rsync(page_config)
            if not success:
                log(f"Rsync skipped or failed for {page_id}.", "WARNING")
                
        # 2. Scanner / Parser to generate rows
        parser_type = page_config.get("parser", {}).get("type", "regex_parser")
        
        body_rows_html = ""
        if parser_type == "database_assets":
            body_rows_html = self.process_database_assets_parser(page_config)
        elif parser_type == "database_personnel":
            body_rows_html = self.process_database_personnel_parser(page_config)
        else:
            # General path scanner
            scanned_files = self.scan_files(page_config.get("scanner", {}))
            
            if parser_type == "regex_parser":
                body_rows_html = self.process_regex_parser(page_config, scanned_files)
            elif parser_type == "date_expiration":
                body_rows_html = self.process_date_expiration_parser(page_config, scanned_files)
            elif parser_type == "coc_dictionary":
                body_rows_html = self.process_coc_dictionary_parser(page_config, scanned_files)
            else:
                log(f"Unknown parser type '{parser_type}' for {page_id}.", "ERROR")
                return False
                
        # 3. Assemble full HTML
        full_html = self.assemble_html(page_config, body_rows_html)
        
        # 4. Deploy (deploy target)
        deploy_target = self.get_absolute_path(page_config.get("html", {}).get("deploy_target"))
        
        # Ensure parent directories exist
        os.makedirs(os.path.dirname(deploy_target), exist_ok=True)
        
        with open(deploy_target, "w") as f:
            f.write(full_html)
            
        log(f"Successfully generated and deployed page to: {deploy_target}", "SUCCESS")
        return True

    def generate_all_pages(self):
        log("Generating all pages in configuration...", "INFO")
        success_count = 0
        total_count = len(self.config.get("pages", []))
        
        for p in self.config.get("pages", []):
            try:
                if self.generate_page(p["id"]):
                    success_count += 1
            except Exception as e:
                log(f"Failed to generate page {p['id']}: {e}", "ERROR")
                
        log(f"Generation completed: {success_count}/{total_count} succeeded.", "SUCCESS")

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="Consolidated HTML Webpage Generator Engine")
    parser.add_argument("--page", help="Generate a specific page by ID")
    parser.add_argument("--all", action="store_true", help="Generate all pages in config")
    parser.add_argument("--config", default="config.json", help="Path to config.json")
    
    args = parser.parse_args()
    engine = GenerationEngine(config_path=args.config)
    
    if args.page:
        engine.generate_page(args.page)
    elif args.all:
        engine.generate_all_pages()
    else:
        parser.print_help()
