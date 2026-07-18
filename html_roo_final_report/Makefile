# Makefile

# To run this code, just run 
#       make run-all
# Target to run all scripts in sequence
#

# Mark non-file targets as PHONY
.PHONY: run-all remove-files remove-files_text

# Target to run all scripts in sequence
run-all: remove-files 01_get_paths 02_genrate_html 03_sed_on_html
	@gum style --foreground 208 --border thick --padding "0 2" "ROO Final Report Pipeline"
	@gum spin --spinner jump --title "Running sequence..." -- bash -c \
		"./01_get_paths.sh && ./02_genrate_html_td.sh && ./03_sed_on_html_sls.sh"
	@$(MAKE) remove-files_text
	@gum style --foreground 85 --border rounded "ROO Final Report system updated successfully."

# Target to remove specific files before starting the scripts
remove-files:
	@rm -f ./output_roo_final_report.html ./pdf_list_roo_final_report.txt
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
# cat ./part1.html ./output_roo_final_report.html ./part2.html > catted_output.html

	@gum spin --spinner points --title "Deploying to server..." -- bash -c "\
	cat ./header_final_report_tag.html ../partial-html_body/nav_tag.html \
	./table_header_tag.html ./output_roo_final_report.html ../partial-html_body/part2.html \
	> catted_output.html && \
	rm -f ./pdf_list_roo_final_report.txt ./output_roo_final_report.html && \
	rm -f '/Volumes/My Passport for Mac/NEOS/Server Backup/WL-SL/Webpage/ROO-Final_Report.html' && \
	cp ./catted_output.html '/Volumes/My Passport for Mac/NEOS/Server Backup/WL-SL/Webpage/ROO-Final_Report.html'"

