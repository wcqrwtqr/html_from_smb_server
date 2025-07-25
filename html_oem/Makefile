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
	./01_get_paths_oem.sh
	./02_genrate_html_td_oem.sh
	./03_sed_on_html_oem.sh
	@echo "All scripts completed."
	$(MAKE) remove-files_text  # Call remove-files_text after scripts

# Target to remove specific files before starting the scripts
remove-files:
	rm -f ./output_oem.html ./pdf_list_oem.txt
	@echo "Removed txt and html files"

# Targets for each individual script
01_get_paths:
	chmod +x ./01_get_paths_oem.sh

02_genrate_html:
	chmod +x ./02_genrate_html_td_oem.sh

03_sed_on_html:
	chmod +x ./03_sed_on_html_oem.sh

# Target to remove specific files before starting the scripts
remove-files_text:
	cat ./part1.html ./output_oem.html ./part2.html > catted_output.html
	rm -f ./pdf_list_oem.txt ./output_oem.html
	@echo "Removed pdf_list_oem.txt and output_oem.html after finish"
	rm -f /Volumes/WL-SL/Webpage/equipment/sls_OEM.html
	cp ./catted_output.html /Volumes/WL-SL/Webpage/equipment/sls_OEM.html
	@echo "Removed the webpage sls_OEM.html and coppied the updated file in its place"

