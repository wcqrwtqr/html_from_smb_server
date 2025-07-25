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
	rm -f ./output_roo_final_report.html ./pdf_list_roo_final_report.txt
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
	cat ./part1.html ./output_roo_final_report.html ./part2.html > catted_output.html
	rm -f ./pdf_list_roo_final_report.txt ./output_roo_final_report.html
	@echo "Removed pdf_list_sls.txt after finish"
	rm -f /Volumes/WL-SL/Webpage/ROO-Final_Report.html
	cp ./catted_output.html /Volumes/WL-SL/Webpage/ROO-Final_Report.html
	@echo "=============================================================="
	@echo "================FINAL REPORT UPDATED IN WEBPAGE==============="
	@echo "=============================================================="


