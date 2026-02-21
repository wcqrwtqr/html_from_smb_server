# Code from ChatGPT for future expand to multi select


Perfect 👍 since your table is growing, let’s build a **proper multi-color + search combined filter system** that supports:

* `text-bg-warning`
* `text-bg-success`
* `text-bg-info`
* `text-bg-danger`
* rows with **no color**
* AND your existing search box together

This will scale cleanly even if you add more colors later.

---

# ✅ Step 1 — Add a Status Filter (Multi-Select)

Place this under your `<h1>` and above the table:

```html
<div class="row mb-3">
  <div class="col-md-4">
    <label class="form-label">Filter by Status</label>
    <select id="colorFilter" class="form-select" multiple>
      <option value="text-bg-warning">Warning (Yellow)</option>
      <option value="text-bg-success">Success (Green)</option>
      <option value="text-bg-info">Info (Blue)</option>
      <option value="text-bg-danger">Danger (Red)</option>
      <option value="no-color">No Color</option>
    </select>
    <div class="form-text">Hold Ctrl (or Cmd on Mac) to select multiple</div>
  </div>
</div>
```

---

# ✅ Step 2 — Replace Your Current Search Script With This Unified Filter Script

Put this before `</body>`:

```html
<script>
const searchInput = document.getElementById("searchInput");
const searchForm = document.getElementById("searchForm");
const colorFilter = document.getElementById("colorFilter");
const rows = document.querySelectorAll("#pdfTable tbody tr");

function filterTable() {
    const searchText = searchInput.value.toLowerCase();

    const selectedColors = Array.from(colorFilter.selectedOptions)
        .map(option => option.value);

    rows.forEach(row => {
        const firstCell = row.querySelector("td");
        if (!firstCell) return;

        const rowText = row.innerText.toLowerCase();

        // --- SEARCH FILTER ---
        const matchesSearch = rowText.includes(searchText);

        // --- COLOR FILTER ---
        let matchesColor = false;

        if (selectedColors.length === 0) {
            matchesColor = true; // no color selected = show all
        } else {
            selectedColors.forEach(colorClass => {
                if (colorClass === "no-color") {
                    if (!firstCell.classList.contains("text-bg-warning") &&
                        !firstCell.classList.contains("text-bg-success") &&
                        !firstCell.classList.contains("text-bg-info") &&
                        !firstCell.classList.contains("text-bg-danger")) {
                        matchesColor = true;
                    }
                } else if (firstCell.classList.contains(colorClass)) {
                    matchesColor = true;
                }
            });
        }

        // --- FINAL DECISION ---
        row.style.display = (matchesSearch && matchesColor) ? "" : "none";
    });
}

// Search submit
searchForm.addEventListener("submit", function(e) {
    e.preventDefault();
    filterTable();
});

// Live search while typing
searchInput.addEventListener("keyup", filterTable);

// Color filter change
colorFilter.addEventListener("change", filterTable);
</script>
```

---

# 🎯 What You Now Have

You can:

* 🔎 Search by any text
* 🟡 Show only warning certificates
* 🟢 Show only success
* 🔵 Show info
* 🔴 Show danger
* Select multiple colors at once
* Combine search + color filtering together

---

# 💡 Example Use Case For You

You could use:

* `text-bg-warning` → Expiring soon
* `text-bg-danger` → Expired
* `text-bg-success` → Valid
* `text-bg-info` → Under review

If you want, I can also:

* Auto-detect expiry date from filename (`EXP 20260223`)
* Automatically color expired certificates red
* Or convert this to a proper DataTable with sorting + pagination

Just tell me what level you want next 😄

