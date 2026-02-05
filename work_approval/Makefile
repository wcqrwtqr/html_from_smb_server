# Makefile

# To run this code, just run 
#       make run-all
# Target to run all scripts in sequence
#

# Mark non-file targets as PHONY
.PHONY: run-all remove-files remove-files_text

# Target to run all scripts in sequence
run-all: remove-files 01_get_paths_personnel_certificate 02_genrate_html_personnel_certificate 03_sed_on_html_personnel_certificate
	@echo "Running all scripts in sequence..."
	./01_get_paths_work_approval.sh
	./02_genrate_html_work_approval.sh
	./03_sed_on_html_work_approval.sh
	@echo "All scripts completed."
	$(MAKE) remove-files_text  # Call remove-files_text after scripts

# Target to remove specific files before starting the scripts
remove-files:
	rm -f ./output_work_approval.html ./pdf_list_work_approval.txt
	@echo "Removed txt and html files"

# Targets for each individual script
01_get_paths_personnel_certificate:
	chmod +x ./01_get_paths_work_approval.sh

02_genrate_html_personnel_certificate:
	chmod +x ./02_genrate_html_work_approval.sh

03_sed_on_html_personnel_certificate:
	chmod +x ./03_sed_on_html_work_approval.sh

# Target to remove specific files before starting the scripts
remove-files_text:
	cat ./header_work_approval_tag.html ../partial-html_body/nav_tag.html ./table_tag.html \
	./output_work_approval.html ../partial-html_body/part2.html > ./work_approval__catted.html

	rm -f ./pdf_list_work_approval.txt 
	@echo "Removed pdf_list_work_approval.txt after finish"

	rm -f /Volumes/WL-SL/Webpage/work_approval.html
	cp ./work_approval__catted.html /Volumes/WL-SL/Webpage/work_approval.html
	@echo "remove webpage all-certificate.html from server and replace it"
	@echo "=============================================================="
	@echo "===============MS sheet UPDATED IN WEBPAGE===================="
	@echo "=============================================================="

