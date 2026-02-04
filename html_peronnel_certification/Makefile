# Makefile

# To run this code, just run 
#       make run-all
# Target to run all scripts in sequence
#

# Mark non-file targets as PHONY
.PHONY: run-all remove-files remove-files_text

# Target to run all scripts in sequence
run-all: remove-files 00_rsync_personnel_certificates 01_get_paths_personnel_certificate 02_genrate_html_personnel_certificate 03_sed_on_html_personnel_certificate
	@echo "Running all scripts in sequence..."
	./00_rsync_personnel_certificates.sh
	./01_get_paths_personnel_certificate.sh
	./02_genrate_html_personnel_certificate.sh
	./03_sed_on_html_personnel_certificate.sh
	@echo "All scripts completed."
	$(MAKE) remove-files_text  # Call remove-files_text after scripts

# Target to remove specific files before starting the scripts
remove-files:
	rm -f ./output_personnel_certificate.html ./pdf_list_personnel.txt
	@echo "Removed txt and html files"

# Targets for each individual script
00_rsync_personnel_certificates:
	chmod +x ./00_rsync_personnel_certificates.sh

01_get_paths_personnel_certificate:
	chmod +x ./01_get_paths_personnel_certificate.sh

02_genrate_html_personnel_certificate:
	chmod +x ./02_genrate_html_personnel_certificate.sh

03_sed_on_html_personnel_certificate:
	chmod +x ./03_sed_on_html_personnel_certificate.sh

# Target to remove specific files before starting the scripts
remove-files_text:
	cat ./header_certificate_tag.html ../partial-html_body/nav_tag.html ./table_tag.html ./output_personnel_certificate.html ../partial-html_body/part2.html > ./personnel_certificate__catted.html
	rm -f ./pdf_list_personnel.txt ./output_personnel_certificate.html
	@echo "Removed pdf_list_truck_maintenance.txt after finish"
	rm -f /Volumes/WL-SL/Webpage/personnel_certificaiton.html
	cp ./personnel_certificate__catted.html /Volumes/WL-SL/Webpage/personnel_certificaiton.html
	@echo "remove webpage all-certificate.html from server and replace it"
	@echo "=============================================================="
	@echo "===============MS sheet UPDATED IN WEBPAGE===================="
	@echo "=============================================================="

