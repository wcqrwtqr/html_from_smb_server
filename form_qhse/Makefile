# Makefile
# To run this code, just run 
#       make run-all
# Target to run all scripts in sequence
#

# Mark non-file targets as PHONY
.PHONY: run-all remove-files remove-files_text

# Target to run all scripts in sequence
run-all: remove-files 00_rsync_form_qhse 01_get_paths_form_qhse \
	02_generate_html_form_qhse 03_sed_on_html_form_qhse
	@echo "Running all scripts in sequence..."
	./00_rsync_form_qhse.sh
	./01_get_paths_form_qhse.sh
	./02_generate_html_form_qhse.sh
	./03_sed_on_html_form_qhse.sh
	@echo "All scripts completed."
	$(MAKE) remove-files_text  # Call remove-files_text after scripts

# Target to remove specific files before starting the scripts
remove-files:
	rm -f ./output_form_qhse.html ./pdf_list_form_qhse.txt
	@echo "Removed txt and html files"

# Targets for each individual script
00_rsync_form_qhse:
	chmod +x ./00_rsync_form_qhse.sh

01_get_paths_form_qhse:
	chmod +x ./01_get_paths_form_qhse.sh

02_generate_html_form_qhse:
	chmod +x ./02_generate_html_form_qhse.sh

03_sed_on_html_form_qhse:
	chmod +x ./03_sed_on_html_form_qhse.sh

# Target to remove specific files before starting the scripts
remove-files_text:
	cat ./header_form_qhse_tag.html ../partial-html_body/nav_tag.html \
	./table_form_qhse_tag.html ./output_form_qhse.html ../partial-html_body/part2.html > \
	./form_qhse__catted.html

	rm -f ./pdf_list_form_qhse.txt ./output_form_qhse.html
	@echo -e "Removed pdf_list_form_qhse.txt after finish"
	rm -f /Volumes/WL-SL/Webpage/form_qhse.html
	cp ./form_qhse__catted.html /Volumes/WL-SL/Webpage/form_qhse.html
	@echo "remove webpage HSE SOP updated.html from server and replace it"
	@echo "=============================================================="
	@echo "=============HSE SOP UPDATED IN WEBPAGE======================="
	@echo "=============================================================="

