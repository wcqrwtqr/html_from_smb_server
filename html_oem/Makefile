# Mark non-file targets as PHONY
.PHONY: run-all remove-files remove-files_text

# Target to run all scripts in sequence
run-all: remove-files 01_get_paths 02_genrate_html 03_sed_on_html
	@gum style --foreground 208 --border thick --padding "0 2" "OEM Manual Pipeline"
	@gum spin --spinner jump --title "Running sequence..." -- bash -c \
		" 	./01_get_paths_oem.sh && ./02_genrate_html_td_oem.sh && ./03_sed_on_html_oem.sh"
	@$(MAKE) remove-files_text
	@gum style --foreground 85 --border rounded "OEM Manual updated successfully."

# Target to remove specific files before starting the scripts
remove-files:
	@rm -f ./output_oem.html ./pdf_list_oem.txt
	@gum log --level info "Cleaning working directory..."

# Targets for each individual script
01_get_paths:
	@chmod +x ./01_get_paths_oem.sh

02_genrate_html:
	@chmod +x ./02_genrate_html_td_oem.sh

03_sed_on_html:
	@chmod +x ./03_sed_on_html_oem.sh

# Target to remove specific files before starting the scripts
remove-files_text:
	@gum spin --spinner points --title "Deploying to server..." -- bash -c "\
	cat ./header_oem_tag.html ../partial-html_body/nav_tag.html \
	./table_oem_tag.html ./output_oem.html ./part2.html > catted_output.html && \
	rm -f ./pdf_list_oem.txt ./output_oem.html && \
	rm -f '/Volumes/My Passport for Mac/NEOS/Server Backup/WL-SL/Webpage/sls_OEM.html' && \
	cp ./catted_output.html '/Volumes/My Passport for Mac/NEOS/Server Backup/WL-SL/Webpage/sls_OEM.html'"

