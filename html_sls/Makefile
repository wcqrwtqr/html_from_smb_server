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
	rm -f ./output_sls.html ./pdf_list_sls.txt
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
	rm -f ./pdf_list_sls.txt
	@echo "Removed pdf_list_sls.txt after finish"


