# Makefile
# To run this code, just run 
#       make run-all
# Target to run all scripts in sequence
#

# Mark non-file targets as PHONY
.PHONY: run-all remove-files remove-files_text

# Target to run all scripts in sequence
run-all: remove-files 01_get_paths_personnel_certificate \
	02_genrate_html_personnel_certificate 03_sed_on_html_personnel_certificate
	@gum style --foreground 208 --border thick --padding "0 2" "Personnel Certificates Pipeline"
	@gum spin --spinner jump --title "Running sequence..." -- bash -c \
		"./01_get_paths_personnel_certificate.sh && ./02_genrate_html_personnel_certificate.sh && ./03_sed_on_html_personnel_certificate.sh"
	@$(MAKE) remove-files_text
	@gum style --foreground 85 --border rounded "WL-SL Forms system updated successfully."

# Target to remove specific files before starting the scripts
remove-files:
	@rm -f ./output_personnel_certificate.html ./pdf_list_personnel.txt
	@gum log --level info "Cleaning working directory..."

01_get_paths_personnel_certificate:
	@chmod +x ./01_get_paths_personnel_certificate.sh

02_genrate_html_personnel_certificate:
	@chmod +x ./02_genrate_html_personnel_certificate.sh

03_sed_on_html_personnel_certificate:
	@chmod +x ./03_sed_on_html_personnel_certificate.sh

# Target to remove specific files before starting the scripts
remove-files_text:
	@gum spin --spinner points --title "Deploying to server..." -- bash -c "\
	cat ./header_certificate_tag.html ../partial-html_body/nav_tag.html ./table_tag.html \
	./output_personnel_certificate.html ../partial-html_body/part2.html > \
	./personnel_certificate__catted.html && \
	cp -f ./pdf_list_personnel.txt ../html_personnel_register/ && \
	rm -f ./pdf_list_personnel.txt ./output_personnel_certificate.html && \
	rm -f '/Volumes/My Passport for Mac/NEOS/Server Backup/WL-SL/Webpage/personnel_certificaiton.html' && \
	cp ./personnel_certificate__catted.html '/Volumes/My Passport for Mac/NEOS/Server Backup/WL-SL/Webpage/personnel_certificaiton.html'"


