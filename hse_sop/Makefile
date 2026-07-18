# Makefile
# To run this code, just run 
#       make run-all
# Target to run all scripts in sequence
#

# Mark non-file targets as PHONY
.PHONY: run-all remove-files remove-files_text

# Target to run all scripts in sequence
run-all: remove-files 01_get_paths_hse_sop 02_generate_html_hse_sop 03_sed_on_html_hse_sop
	@gum style --foreground 208 --border thick --padding "0 2" "HSE SOP Pipeline"
	@gum spin --spinner jump --title "Running sequence..." -- bash -c \
		"./01_get_paths_hse_sop.sh && ./02_generate_html_hse_sop.sh && ./03_sed_on_html_hse_sop.sh"
	@$(MAKE) remove-files_text
	@gum style --foreground 85 --border rounded "HSE SOP updated successfully."

# Target to remove specific files before starting the scripts
remove-files:
	@rm -f ./output_hse_sop.html ./pdf_list_hse_sop.txt
	@gum log --level info "Cleaning working directory..."

01_get_paths_hse_sop:
	@chmod +x ./01_get_paths_hse_sop.sh

02_generate_html_hse_sop:
	@chmod +x ./02_generate_html_hse_sop.sh

03_sed_on_html_hse_sop:
	@chmod +x ./03_sed_on_html_hse_sop.sh

# Target to remove specific files before starting the scripts
remove-files_text:
	@gum spin --spinner points --title "Deploying to server..." -- bash -c "\
	cat ./header_hse_sop_tag.html ../partial-html_body/nav_tag.html \
	./table_hse_sop_tag.html ./output_hse_sop.html ../partial-html_body/part2.html > \
	./hse_sop__catted.html && \
	rm -f ./pdf_list_hse_sop.txt ./output_hse_sop.html && \
	rm -f '/Volumes/My Passport for Mac/NEOS/Server Backup/WL-SL/Webpage/hse_sop.html' && \
	cp ./hse_sop__catted.html '/Volumes/My Passport for Mac/NEOS/Server Backup/WL-SL/Webpage/hse_sop.html'"
