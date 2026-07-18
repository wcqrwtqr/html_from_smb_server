# Makefile

# To run this code, just run 
#       make run-all
# Target to run all scripts in sequence
#

# Mark non-file targets as PHONY
.PHONY: run-all remove-files remove-files_text

# Target to run all scripts in sequence
run-all: remove-files 01_get_paths 02_genrate_html 03_sed_on_html 
	@gum style --foreground 135 --border normal --padding "0 2" "Certificate Generation Pipeline"
	@gum spin --spinner globe --title "Running SLS scripts..." -- bash -c \
		"./01_get_paths_certificate.sh && ./02_genrate_html_td_certificate.sh && ./03_sed_on_html_certificate.sh"
	@$(MAKE) remove-files_text
	@gum style --foreground 46 --border rounded "Certificate system updated successfully."

# Target to remove specific files before starting the scripts
remove-files:
	@rm -f ./output_certificate.html ./pdf_list_certificate.txt
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
	@gum spin --spinner minidot --title "Deploying to server..." -- bash -c "\
		cat ./header_certificate_tag.html ../partial-html_body/nav_tag.html \
		./table_tag.html ./output_certificate.html ../partial-html_body/part2.html > final_certificate.html && \
		rm -f ./output_certificate.html && \
		cp ./pdf_list_certificate.txt ../html_asset_register && \
		cp ./final_certificate.html '/Volumes/My Passport for Mac/NEOS/Server Backup/WL-SL/Webpage/all-certificate.html'"


