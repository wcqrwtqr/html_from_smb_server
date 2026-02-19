# Makefile

# To run this code, just run 
#       make run-all
# Target to run all scripts in sequence
#

# Mark non-file targets as PHONY
.PHONY: run-all remove-files remove-files_text

# Target to run all scripts in sequence
run-all: remove-files 01_get_paths 02_genrate_html 03_sed_on_html
	@echo "Running all scripts in sequence..."
	./01_get_paths_oem-manual.sh
	./02_genrate_html_td_oem-manual.sh
	./03_sed_on_html_oem-manual.sh
	@echo "All scripts completed."
	$(MAKE) remove-files_text  # Call remove-files_text after scripts

# Target to remove specific files before starting the scripts
remove-files:
	rm -f ./output_oem-manual.html ./pdf_list_oem-manual.txt
	@echo "Removed txt and html files"

# Targets for each individual script
01_get_paths:
	chmod +x ./01_get_paths_oem-manual.sh

02_genrate_html:
	chmod +x ./02_genrate_html_td_oem-manual.sh

03_sed_on_html:
	chmod +x ./03_sed_on_html_oem-manual.sh

# Target to remove specific files before starting the scripts
remove-files_text:
	cat ./header_oem-manual_tag.html ../partial-html_body/nav_tag.html \
	./table_tag.html ./output_oem-manual.html ./part2.html \
	> final_oem-manual.html
# rm -f ./pdf_list_oem-manual.txt ./output_oem-manual.html
	rm -f ./output_oem-manual.html
# cp ./pdf_list_oem-manual.txt ../html_asset_register
	@echo "Removed pdf_list_truck_maintenance.txt after finish"
	rm -f /Volumes/WL-SL/Webpage/oem_manual.html
	cp ./final_oem-manual.html /Volumes/WL-SL/Webpage/oem_manual.html
	@echo "remove webpage all-oem-manual.html from server and replace it"
	@echo "=============================================================="
	@echo "=============OEM-MANUAL UPDATED IN WEBPAGE==================="
	@echo "=============================================================="

