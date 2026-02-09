# Makefile
# To run this code, just run 
#       make run-all
# Target to run all scripts in sequence
#

# Mark non-file targets as PHONY
.PHONY: run-all remove-files remove-files_text

# Target to run all scripts in sequence
run-all: remove-files 00_rsync_ims_sop 01_get_paths_ims_sop 02_generate_html_ims_sop 03_sed_on_html_ims_sop
	@echo "Running all scripts in sequence..."
	./00_rsync_roo_sop.sh
	./01_get_paths_roo_sop.sh
	./02_generate_html_roo_sop.sh
	./03_sed_on_html_roo_sop.sh
	@echo "All scripts completed."
	$(MAKE) remove-files_text  # Call remove-files_text after scripts

# Target to remove specific files before starting the scripts
remove-files:
	rm -f ./output_roo_sop.html ./pdf_list_roo_sop.txt
	@echo "Removed txt and html files"

# Targets for each individual script
00_rsync_ims_sop:
	chmod +x ./00_rsync_roo_sop.sh

01_get_paths_ims_sop:
	chmod +x ./01_get_paths_roo_sop.sh

02_generate_html_ims_sop:
	chmod +x ./02_generate_html_roo_sop.sh

03_sed_on_html_ims_sop:
	chmod +x ./03_sed_on_html_roo_sop.sh

# Target to remove specific files before starting the scripts
remove-files_text:
	cat ./header_roo_sop_tag.html ../partial-html_body/nav_tag.html \
	./table_roo_sop_tag.html ./output_roo_sop.html ../partial-html_body/part2.html > \
	./roo_sop__catted.html

	rm -f ./pdf_list_roo_sop.txt ./output_roo_sop.html
	@echo -e "Removed pdf_list_roo_sop.txt after finish"
	rm -f /Volumes/WL-SL/Webpage/roo_sop.html
	cp ./roo_sop__catted.html /Volumes/WL-SL/Webpage/roo_sop.html
	@echo "remove webpage IMS SOP updated.html from server and replace it"
	@echo "=============================================================="
	@echo "=============IMS SOP ROO UPDATED IN WEBPAGE==================="
	@echo "=============================================================="

