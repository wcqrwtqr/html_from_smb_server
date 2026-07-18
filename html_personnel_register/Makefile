# Makefile

# Mark non-file targets as PHONY
.PHONY: run-all remove-files remove-files_text

# Target to run all scripts in sequence
run-all: remove-files 01_get_personnel_from_db
	@gum style --foreground 208 --border thick --padding "0 2" "Personnel Register Pipeline"
	@gum spin --spinner jump --title "Running sequence..." -- bash -c \
		"./01_get_personel_from_db.sh"
	@$(MAKE) remove-files_text
	@gum style --foreground 85 --border rounded "Personnel Register updated successfully."

# Target to remove specific files before starting the scripts
remove-files:
	@rm -f ./output_personnel.html 
	@gum log --level info "Cleaning working directory..."

# Targets for each individual script
01_get_personnel_from_db:
	@chmod +x ./01_get_personel_from_db.sh

# Target to remove specific files before starting the scripts

remove-files_text:
	@gum spin --spinner points --title "Deploying to server..." -- bash -c "\
	cat ./header_personnel_register_tag.html ../partial-html_body/nav_tag.html \
	./table_tag.html ./personnel_table.html ./part2.html > ./final_personnel_page.html && \
	rm -f '/Volumes/My Passport for Mac/NEOS/Server Backup/WL-SL/Webpage/personnel_register.html' && \
	cp ./final_personnel_page.html '/Volumes/My Passport for Mac/NEOS/Server Backup/WL-SL/Webpage/personnel_register.html'"
