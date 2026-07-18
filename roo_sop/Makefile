# Makefile
# To run this code, just run 
#       make run-all
# Target to run all scripts in sequence
#

# Mark non-file targets as PHONY
.PHONY: run-all remove-files remove-files_text

# Target to run all scripts in sequence
run-all: remove-files 01_get_paths_ims_sop 02_generate_html_ims_sop 03_sed_on_html_ims_sop
	@gum style --foreground 208 --border thick --padding "0 2" "ROO SOP Pipeline"
	@gum spin --spinner jump --title "Running sequence..." -- bash -c \
		"./01_get_paths_roo_sop.sh && ./02_generate_html_roo_sop.sh && ./03_sed_on_html_roo_sop.sh"
	@$(MAKE) remove-files_text
	@gum style --foreground 85 --border rounded "ROO SOP updated successfully."


# Target to remove specific files before starting the scripts
remove-files:
	@rm -f ./output_roo_sop.html ./pdf_list_roo_sop.txt
	@echo "Removed txt and html files"

# Targets for each individual script
# 00_rsync_ims_sop:
# 	chmod +x ./00_rsync_roo_sop.sh

01_get_paths_ims_sop:
	@chmod +x ./01_get_paths_roo_sop.sh

02_generate_html_ims_sop:
	@chmod +x ./02_generate_html_roo_sop.sh

03_sed_on_html_ims_sop:
	@chmod +x ./03_sed_on_html_roo_sop.sh

# Target to remove specific files before starting the scripts
remove-files_text:

	@gum spin --spinner points --title "Deploying to server..." -- bash -c "\
	cat ./header_roo_sop_tag.html ../partial-html_body/nav_tag.html \
	./table_roo_sop_tag.html ./output_roo_sop.html ../partial-html_body/part2.html > \
	./roo_sop__catted.html && \
	rm -f ./pdf_list_roo_sop.txt ./output_roo_sop.html && \
	rm -f '/Volumes/My Passport for Mac/NEOS/Server Backup/WL-SL/Webpage/roo_sop.html' && \
	cp ./roo_sop__catted.html '/Volumes/My Passport for Mac/NEOS/Server Backup/WL-SL/Webpage/roo_sop.html'"


