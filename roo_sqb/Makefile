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
	./01_get_paths.sh
	./02_genrate_html_td.sh
	./03_sed_on_html_sls.sh
	@echo "All scripts completed."
	$(MAKE) remove-files_text  # Call remove-files_text after scripts

# Target to remove specific files before starting the scripts
remove-files:
	rm -f ./output_roo_sqb.html ./pdf_list_roo_sqb.txt
	@echo "Removed txt and html files"

# Targets for each individual script
01_get_paths:
	chmod +x ./01_get_paths.sh

02_genrate_html:
	chmod +x ./02_genrate_html_td.sh

03_sed_on_html:
	chmod +x ./03_sed_on_html_sls.sh

# Target to remove specific files before starting the scripts
remove-files_text:
	cat ./header_sqb_tag.html ../partial-html_body/nav_tag.html ./table_sqb_tag.html ./output_roo_sqb.html ./part2.html > catted_sqb.html
	cat ../partial-html_body/index_header.html ../partial-html_body/nav_tag.html ../partial-html_body/index_footer.html > catted_index.html
	rm -f ./pdf_list_roo_sqb.txt ./output_roo_sqb.html
	rm -f /Volumes/WL-SL/Webpage/index.html
	@echo "Removed pdf_list_sls.txt after finish"
	rm -f /Volumes/WL-SL/Webpage/ROO-SQB.html
	cp ./catted_sqb.html /Volumes/WL-SL/Webpage/ROO-SQB.html
	cp ./catted_index.html /Volumes/WL-SL/Webpage/index.html
	@echo "Removed the webpage sls_sqb.html and coppied the updated file in its place"
	@echo "=============================================================="
	@echo "==================SQB UPDATED IN WEBPAGE======================"
	@echo "=============================================================="



