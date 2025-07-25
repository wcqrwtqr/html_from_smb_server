# Makefile

# To run this code, just run 
#       make run-all
# Target to run all scripts in sequence
#

# Mark non-file targets as PHONY
.PHONY: run-all remove-files remove-files_text

# Target to run all scripts in sequence
run-all: remove-files 01_get_paths.sh 02_genrate_html_IMS_for_yasir.sh 03_sed_on_html.sh remove-files_text
	@echo "Running all scripts in sequence..."
	./01_get_paths.sh
	./02_genrate_html_IMS_for_sls.sh
	./03_sed_on_html.sh
	@echo "All scripts completed."
	$(MAKE) remove-files_text  # Call remove-files_text after scripts

# Target to remove specific files before starting the scripts
remove-files:
	rm -f ./output_ims_sls.html ./pdf_list_ims_sls.txt
	@echo "Removed file1.txt and file2.txt if they existed."

# Targets for each individual script
01_get_paths.sh:
	chmod +x ./01_get_paths.sh

02_genrate_html_IMS_for_yasir.sh:
	chmod +x ./02_genrate_html_IMS_for_sls.sh

03_sed_on_html.sh:
	chmod +x 03_sed_on_html.sh

# Target to remove specific files before starting the scripts
remove-files_text:
	rm -f ./pdf_list_ims_sls.txt
	@echo "Removed pdf_list_ims_from_yasir.txt after finish"
