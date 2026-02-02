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
	./01_get_paths_certificate.sh
	./02_genrate_html_td_certificate.sh
	./03_sed_on_html_certificate.sh
	@echo "All scripts completed."
	$(MAKE) remove-files_text  # Call remove-files_text after scripts

# Target to remove specific files before starting the scripts
remove-files:
	rm -f ./output_certificate.html ./pdf_list_certificate.txt
	@echo "Removed txt and html files"

# Targets for each individual script
01_get_paths:
	chmod +x ./01_get_paths_certificate.sh

02_genrate_html:
	chmod +x ./02_genrate_html_td_certificate.sh

03_sed_on_html:
	chmod +x ./03_sed_on_html_certificate.sh

# Target to remove specific files before starting the scripts
remove-files_text:
	cat ./header_certificate_tag.html ../partial-html_body/nav_tag.html ./table_tag.html ./output_certificate.html ./part2.html > final_certificate.html
	rm -f ./pdf_list_certificate.txt ./output_certificate.html
	@echo "Removed pdf_list_truck_maintenance.txt after finish"
	rm -f /Volumes/WL-SL/Webpage/equipment/all-certificate.html
	cp ./final_certificate.html /Volumes/WL-SL/Webpage/equipment/all-certificate.html
	@echo "remove webpage all-certificate.html from server and replace it"
	@echo "=============================================================="
	@echo "=============CERTIFICAT UPDATED IN WEBPAGE===================="
	@echo "=============================================================="

