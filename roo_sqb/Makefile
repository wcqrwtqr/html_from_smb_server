# Makefile

# To run this code, just run 
#       make run-all
# Target to run all scripts in sequence
#

# Mark non-file targets as PHONY
.PHONY: run-all remove-files remove-files_text

# Target to run all scripts in sequence
run-all: remove-files 01_get_paths 02_genrate_html 03_sed_on_html
	@gum style --foreground 208 --border thick --padding "0 2" "ROO SQB Pipeline"
	@gum spin --spinner jump --title "Running sequence..." -- bash -c \
		"./01_get_paths.sh && ./02_genrate_html_td.sh && ./03_sed_on_html_sls.sh"
	@$(MAKE) remove-files_text
	@gum style --foreground 85 --border rounded "ROO SQB updated successfully."

# Target to remove specific files before starting the scripts
remove-files:
	@rm -f ./output_roo_sqb.html ./pdf_list_roo_sqb.txt
	@gum log --level info "Cleaning working directory..."

# Targets for each individual script
01_get_paths:
	@chmod +x ./01_get_paths.sh

02_genrate_html:
	@chmod +x ./02_genrate_html_td.sh

03_sed_on_html:
	@chmod +x ./03_sed_on_html_sls.sh

# Target to remove specific files before starting the scripts
remove-files_text:
	@gum spin --spinner points --title "Deploying to server..." -- bash -c "\
	cat ./header_sqb_tag.html ../partial-html_body/nav_tag.html \
	./table_sqb_tag.html ./output_roo_sqb.html ./part2.html > catted_sqb.html && \
	rm -f ./pdf_list_roo_sqb.txt ./output_roo_sqb.html && \
	rm -f '/Volumes/My Passport for Mac/NEOS/Server Backup/WL-SL/Webpage/ROO-SQB.html' && \
	cp ./catted_sqb.html  '/Volumes/My Passport for Mac/NEOS/Server Backup/WL-SL/Webpage/ROO-SQB.html'"


