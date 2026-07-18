# Makefile
# To run this code, just run 
#       make run-all
# Target to run all scripts in sequence
#

# Mark non-file targets as PHONY
.PHONY: run-all remove-files remove-files_text

# Target to run all scripts in sequence
run-all: remove-files 01_get_paths_form_wl-sl 02_generate_html_form_wl-sl 03_sed_on_html_form_wl-sl
	@gum style --foreground 208 --border thick --padding "0 2" "WL-SL Forms Pipeline"
	@gum spin --spinner jump --title "Running sequence..." -- bash -c \
		"./01_get_paths_form_wl-sl.sh && ./02_generate_html_form_wl-sl.sh && ./03_sed_on_html_form_wl-sl.sh"
	@$(MAKE) remove-files_text
	@gum style --foreground 85 --border rounded "WL-SL Forms system updated successfully."

# Target to remove specific files before starting the scripts
remove-files:
	@rm -f ./output_form_wl-sl.html ./pdf_list_form_wl-sl.txt
	@gum log --level info "Cleaning working directory..."

01_get_paths_form_wl-sl:
	@chmod +x ./01_get_paths_form_wl-sl.sh

02_generate_html_form_wl-sl:
	@chmod +x ./02_generate_html_form_wl-sl.sh

03_sed_on_html_form_wl-sl:
	@chmod +x ./03_sed_on_html_form_wl-sl.sh

# Targ
remove-files_text:
	@gum spin --spinner points --title "Deploying to server..." -- bash -c "\
	cat ./header_form_wl-sl_tag.html ../partial-html_body/nav_tag.html \
	./table_form_wl-sl_tag.html ./output_form_wl-sl.html ../partial-html_body/part2.html > \
	./form_wl-sl__catted.html && \
	rm -f ./pdf_list_form_wl-sl.txt ./output_form_wl-sl.html && \
	rm -f '/Volumes/My Passport for Mac/NEOS/Server Backup/WL-SL/Webpage/form_wl-sl.html' && \
	cp ./form_wl-sl__catted.html '/Volumes/My Passport for Mac/NEOS/Server Backup/WL-SL/Webpage/form_wl-sl.html'"

