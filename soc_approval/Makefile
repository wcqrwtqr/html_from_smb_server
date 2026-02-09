# Makefile

# To run this code, just run 
#       make run-all
# Target to run all scripts in sequence
#

# Mark non-file targets as PHONY
.PHONY: run-all remove-files remove-files_text

# Target to run all scripts in sequence
run-all: remove-files 01_get_paths_personnel_certificate 02_generate_html_soc_approval 03_sed_on_html_soc_approval
	@echo "Running all scripts in sequence..."
	./01_get_paths_soc_approval.sh
	./02_generate_html_soc_approval.sh
	./03_sed_on_html_soc_approval.sh
	@echo "All scripts completed."
	$(MAKE) remove-files_text  # Call remove-files_text after scripts

# Target to remove specific files before starting the scripts
remove-files:
	rm -f ./output_soc_approval.html ./pdf_list_soc_approval.txt
	@echo "Removed txt and html files"

# Targets for each individual script
01_get_paths_personnel_certificate:
	chmod +x ./01_get_paths_soc_approval.sh

02_generate_html_soc_approval:
	chmod +x ./02_generate_html_soc_approval.sh

03_sed_on_html_soc_approval:
	chmod +x ./03_sed_on_html_soc_approval.sh

# Target to remove specific files before starting the scripts
remove-files_text:
	cat ./header_soc_approval_tag.html ../partial-html_body/nav_tag.html ./table_tag.html \
	./output_soc_approval.html ../partial-html_body/part2.html > ./soc_approval__catted.html

	rm -f ./pdf_list_soc_approval.txt 
	@echo "Removed pdf_list_soc_approval.txt after finish"

	rm -f /Volumes/WL-SL/Webpage/soc_approval.html
	cp ./soc_approval__catted.html /Volumes/WL-SL/Webpage/soc_approval.html
	@echo "remove webpage all-certificate.html from server and replace it"
	@echo "=============================================================="
	@echo "===============SOC APPROVAL UPDATED IN WEBPAGE================"
	@echo "=============================================================="

