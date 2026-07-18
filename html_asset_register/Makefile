# Makefile

# To run this code, just run 
#       make run-all
# Target to run all scripts in sequence
#

# Mark non-file targets as PHONY
.PHONY: run-all remove-files remove-files_text

run-all: remove-files 01_get_asset_from_db
	@gum style --foreground 39 --border double --padding "0 2" "Asset Register Pipeline"
	@gum spin --spinner monkey --title "Fetching data from DB..." -- ./01_get_asset_from_db.sh
	@$(MAKE) remove-files_text
	@gum style --foreground 46 --border rounded "Asset Register successfully synchronized to website."


# Target to remove specific files before starting the scripts
remove-files:
	@rm -f ./output_certificate.html ./pdf_list_asset_db.txt
	@gum log --level info --format "Removed txt and html files"

# Targets for each individual script
01_get_asset_from_db:
	@chmod +x ./01_get_asset_from_db.sh

remove-files_text:
	@gum spin --spinner pulse --title "Finalizing and Deploying..." -- bash -c "\
		cat ./header_asset_register_tag.html ../partial-html_body/nav_tag.html \
		./table_tag.html ./assets_table.html ./part2.html > ./final_asset_page.html && \
		rm -f ./assets_table.html ./pdf_list_asset_db.txt && \
		cp ./script/asset-register-filter.js '/Volumes/My Passport for Mac/NEOS/Server Backup/WL-SL/Webpage/script/asset-register-filter.js' && \
		cp ./final_asset_page.html '/Volumes/My Passport for Mac/NEOS/Server Backup/WL-SL/Webpage/assets_register.html'"
