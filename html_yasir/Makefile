# Makefile

# Created: 29 Oct 2024
# To run this code, just run 
#       make run-all
# Target to run all scripts in sequence
# The script will create the final html page 
# and will copy it to the correct place in IMS 
# Webpage so there is no need to modify from within
# emacs 

# Mark non-file targets as PHONY
.PHONY: run-all remove-files remove-files_text

# Target to run all scripts in sequence
run-all: remove-files 01_get_paths.sh 02_genrate_html_IMS_for_yasir.sh 03_sed_on_html.sh
	@echo "Running all scripts in sequence..."
	./01_get_paths.sh
	./02_genrate_html_IMS_for_yasir.sh
	./03_sed_on_html.sh
	@echo "All scripts completed."
	$(MAKE) remove-files_text  # Call remove-files_text after scripts

# Target to remove specific files before starting the scripts
remove-files:
	rm -f ./pdf_list_ims_from_yasir.txt ./final_yasir.html
	@echo "Removed file1.txt and file2.txt if they existed."

# Targets for each individual script
01_get_paths.sh:
	chmod +x 01_get_paths.sh

02_genrate_html_IMS_for_yasir.sh:
	chmod +x 02_genrate_html_IMS_for_yasir.sh

03_sed_on_html.sh:
	chmod +x 03_sed_on_html.sh

# Target to remove specific files before starting the scripts
remove-files_text:
	cat ./part1.html ./output_ims.html ./part2.html > final_yasir.html 
	rm -f ./pdf_list_ims_from_yasir.txt ./output_ims.html
	@echo "Removed pdf_list_ims_from_yasir.txt after finish"
	cp ./final_yasir.html /Volumes/IMS/webpage_ims/index.html
	@echo "Moving the new updated html to IMS webpage folder"
