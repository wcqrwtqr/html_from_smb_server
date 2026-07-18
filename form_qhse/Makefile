# Makefile
# To run this code, just run 
#       make run-all
# Target to run all scripts in sequence
#

# Mark non-file targets as PHONY
.PHONY: run-all remove-files remove-files_text

# Target to run all scripts in sequence
run-all: remove-files 01_get_paths_form_qhse 02_generate_html_form_qhse 03_sed_on_html_form_qhse
	@gum style --foreground 212 --bold "Starting QHSE Form Pipeline..."
	@gum spin --spinner dot --title "Processing files..." -- bash -c \
		"./01_get_paths_form_qhse.sh && ./02_generate_html_form_qhse.sh && ./03_sed_on_html_form_qhse.sh"
	@$(MAKE) remove-files_text
	@gum style --foreground 46 --border rounded "Pipeline Complete! HSE Form updated on Server."

# Target to remove specific files before starting the scripts
remove-files:
	@rm -f ./output_form_qhse.html ./pdf_list_form_qhse.txt
	@echo "Removed txt and html files"

01_get_paths_form_qhse:
	@chmod +x ./01_get_paths_form_qhse.sh

02_generate_html_form_qhse:
	@chmod +x ./02_generate_html_form_qhse.sh

03_sed_on_html_form_qhse:
	@chmod +x ./03_sed_on_html_form_qhse.sh

# Target to remove specific files before starting the scripts
remove-files_text:
	@gum spin --spinner line --title "Finalizing and deploying to server..." -- bash -c "\
		cat ./header_form_qhse_tag.html ../partial-html_body/nav_tag.html \
		./table_form_qhse_tag.html ./output_form_qhse.html ../partial-html_body/part2.html > ./form_qhse__catted.html && \
		rm -f ./pdf_list_form_qhse.txt ./output_form_qhse.html && \
		cp ./form_qhse__catted.html '/Volumes/My Passport for Mac/NEOS/Server Backup/WL-SL/Webpage/form_qhse.html'"
