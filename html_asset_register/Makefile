# Makefile

# To run this code, just run 
#       make run-all
# Target to run all scripts in sequence
#

# Mark non-file targets as PHONY
.PHONY: run-all remove-files remove-files_text

# Target to run all scripts in sequence
run-all: remove-files 01_get_asset_from_db
	@echo "Running all scripts in sequence..."
	./01_get_asset_from_db.sh
	@echo "All scripts completed."
	$(MAKE) remove-files_text  # Call remove-files_text after scripts

# Target to remove specific files before starting the scripts
remove-files:
	rm -f ./output_certificate.html ./pdf_list_asset_db.txt
	@echo "Removed txt and html files"

# Targets for each individual script
01_get_asset_from_db:
	chmod +x ./01_get_asset_from_db.sh

# Target to remove specific files before starting the scripts
remove-files_text:
	cat ./header_asset_register_tag.html ../partial-html_body/nav_tag.html \
	./table_tag.html ./assets_table.html ./part2.html > ./final_asset_page.html
	rm -f ./assets_table.html ./pdf_list_asset_db.txt
	@echo "Removed pdf_list_list_db.txt after finish"
	rm -f /Volumes/WL-SL/Webpage/assets_register.html /Volumes/WL-SL/Webpage/script/asset-register-filter.js
	cp ./script/asset-register-filter.js /Volumes/WL-SL/Webpage/script/asset-register-filter.js
	cp ./final_asset_page.html /Volumes/WL-SL/Webpage/assets_register.html
	@echo "remove webpage assets_register.html from server and replace it"
	@echo "=============================================================="
	@echo "==================Asset UPDATED IN WEBPAGE===================="
	@echo "=============================================================="

