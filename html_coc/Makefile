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
	./00_get_dict_sn_desc.sh
	./01_get_paths.sh
	./02_genrate_html_td.sh
	./03_sed_on_html_sls.sh
	@echo "All scripts completed."
	$(MAKE) remove-files_text  # Call remove-files_text after scripts

# Target to remove specific files before starting the scripts
remove-files:
	rm -f ./output_coc.html ./pdf_list_coc.txt
	@echo "Removed txt and html files"

# Targets for each individual script
00_get_dict_sn_desc:
	chmod +x ./00_get_dict_sn_desc.sh
01_get_paths:
	chmod +x ./01_get_paths.sh

02_genrate_html:
	chmod +x ./02_genrate_html_td.sh

03_sed_on_html:
	chmod +x ./03_sed_on_html_sls.sh

# Target to remove specific files before starting the scripts
remove-files_text:
# cat ./part1.html ./output_coc.html ./part2.html > catted_output.html
	cat ./header_coc_tag.html ../partial-html_body/nav_tag.html ./table_header_tag.html ./output_coc.html ./part2.html > catted_output.html
	rm -f ./pdf_list_coc.txt ./output_coc.html
	@echo "Removed pdf_list_sls.txt after finish"
	rm -f /Volumes/WL-SL/Webpage/sls_coc_nov.html
	@echo "Removed pdf_list_sls.txt after finish"
	cp ./catted_output.html /Volumes/WL-SL/Webpage/sls_coc_nov.html
	@echo "=============================================================="
	@echo "================FINAL REPORT UPDATED IN WEBPAGE==============="
	@echo "=============================================================="


