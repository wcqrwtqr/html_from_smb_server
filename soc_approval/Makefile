# Makefile

# To run this code, just run 
#       make run-all
# Target to run all scripts in sequence
#

# Mark non-file targets as PHONY
.PHONY: run-all remove-files remove-files_text

# Target to run all scripts in sequence
run-all: remove-files 01_get_paths_personnel_certificate 02_generate_html_soc_approval 03_sed_on_html_soc_approval
	@gum style --foreground 208 --border thick --padding "0 2" "SOC Approval Pipeline"
	@gum spin --spinner jump --title "Running sequence..." -- bash -c \
		"	./01_get_paths_soc_approval.sh && ./02_generate_html_soc_approval.sh && ./03_sed_on_html_soc_approval.sh"
	@$(MAKE) remove-files_text
	@gum style --foreground 85 --border rounded "SOC Approval updated successfully."

# Target to remove specific files before starting the scripts
remove-files:
	@rm -f ./output_soc_approval.html ./pdf_list_soc_approval.txt
	@echo "Removed txt and html files"

# Targets for each individual script
01_get_paths_personnel_certificate:
	@chmod +x ./01_get_paths_soc_approval.sh

02_generate_html_soc_approval:
	@chmod +x ./02_generate_html_soc_approval.sh

03_sed_on_html_soc_approval:
	@chmod +x ./03_sed_on_html_soc_approval.sh

# Target to remove specific files before starting the scripts
remove-files_text:
	@gum spin --spinner points --title "Deploying to server..." -- bash -c "\
	cat ./header_soc_approval_tag.html ../partial-html_body/nav_tag.html ./table_tag.html \
	./output_soc_approval.html ../partial-html_body/part2.html > ./soc_approval__catted.html && \
	rm -f ./pdf_list_soc_approval.txt && \
	rm -f '/Volumes/My Passport for Mac/NEOS/Server Backup/WL-SL/Webpage/soc_approval.html' && \
	cp ./soc_approval__catted.html '/Volumes/My Passport for Mac/NEOS/Server Backup/WL-SL/Webpage/soc_approval.html'"

