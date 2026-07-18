# Mark non-file targets as PHONY
.PHONY: run-all remove-files remove-files_text

# Target to run all scripts in sequence
run-all: remove-files 01_get_paths 02_genrate_html 03_sed_on_html
	@gum style --foreground 208 --border thick --padding "0 2" "PCE Maintenance Pipeline"
	@gum spin --spinner jump --title "Running sequence..." -- bash -c \
		"./01_get_paths_certificate.sh && ./02_genrate_html_td_certificate.sh && ./03_sed_on_html_certificate.sh"
	@$(MAKE) remove-files_text
	@gum style --foreground 85 --border rounded "PCE Maintenance system updated successfully."

# Target to remove specific files before starting the scripts
remove-files:
	@rm -f ./output_ms.html ./pdf_list_ms.txt
	@gum log --level debug "Cleaning working directory..."

# Targets for each individual script
01_get_paths:
	@chmod +x ./01_get_paths_certificate.sh

02_genrate_html:
	@chmod +x ./02_genrate_html_td_certificate.sh

03_sed_on_html:
	@chmod +x ./03_sed_on_html_certificate.sh

# Target to remove specific files before starting the scripts
remove-files_text:
	@gum spin --spinner points --title "Deploying to server..." -- bash -c "\
		cat ./header_certificate_tag.html ../partial-html_body/nav_tag.html ./table_tag.html ./output_ms.html ./part2.html > ./final_pce_ms_catted.html && \
		rm -f ./pdf_list_ms.txt ./output_ms.html && \
		rm -f '/Volumes/My Passport for Mac/NEOS/Server Backup/WL-SL/Webpage/sls_pce_ms.html' && \
		cp ./final_pce_ms_catted.html '/Volumes/My Passport for Mac/NEOS/Server Backup/WL-SL/Webpage/sls_pce_ms.html'"
