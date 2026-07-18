# Makefile

# To run this code, just run 
#       make run-all
# Target to run all scripts in sequence
#

# Mark non-file targets as PHONY
.PHONY: run-all remove-files remove-files_text

# Target to run all scripts in sequence
run-all: remove-files 00_get_dict_sn_desc 01_get_paths 02_genrate_html 03_sed_on_html
	@gum style --foreground 208 --border thick --padding "0 2" "COC Pipeline"
	@gum spin --spinner jump --title "Running COC scripts..." -- bash -c \
		"./00_get_dict_sn_desc.sh && ./01_get_paths.sh && ./02_genrate_html_td.sh && ./03_sed_on_html_sls.sh"
	@$(MAKE) remove-files_text
	@gum style --foreground 85 --border rounded "Certificate system updated successfully."

# Target to remove specific files before starting the scripts
remove-files:
	@rm -f ./output_coc.html ./pdf_list_coc.txt
	@gum log --level debug "Cleaning working directory..."

# Targets for each individual script
00_get_dict_sn_desc:
	@chmod +x ./00_get_dict_sn_desc.sh
01_get_paths:
	@chmod +x ./01_get_paths.sh

02_genrate_html:
	@chmod +x ./02_genrate_html_td.sh

03_sed_on_html:
	@chmod +x ./03_sed_on_html_sls.sh

# Target to remove specific files before starting the scripts
remove-files_text:
	@gum spin --spinner points --title "Deploying to server..." -- bash -c "\
		cat ./header_coc_tag.html ../partial-html_body/nav_tag.html ./table_header_tag.html ./output_coc.html ../partial-html_body/part2.html > catted_output.html && \
		cp ./pdf_list_coc.txt ../html_asset_register/ && \
		rm -f ./pdf_list_coc.txt ./output_coc.html && \
		cp ./catted_output.html '/Volumes/My Passport for Mac/NEOS/Server Backup/WL-SL/Webpage/sls_coc_nov.html'"


