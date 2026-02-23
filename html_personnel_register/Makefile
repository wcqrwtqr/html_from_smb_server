# Makefile

# Mark non-file targets as PHONY
.PHONY: run-all remove-files remove-files_text

# Target to run all scripts in sequence
run-all: remove-files 01_get_personnel_from_db
	@echo "Running all scripts in sequence..."
	./01_get_personel_from_db.sh
	@echo "All scripts completed."
	$(MAKE) remove-files_text  # Call remove-files_text after scripts

# Target to remove specific files before starting the scripts
remove-files:
	rm -f ./output_personnel.html 
	@echo "Removed txt and html files"

# Targets for each individual script
01_get_personnel_from_db:
	chmod +x ./01_get_personel_from_db.sh

# Target to remove specific files before starting the scripts
remove-files_text:
	cat ./header_personnel_register_tag.html ../partial-html_body/nav_tag.html \
	./table_tag.html ./personnel_table.html ./part2.html > ./final_personnel_page.html
	@echo "Removed pdf_list_list_db.txt after finish"
	rm -f /Volumes/WL-SL/Webpage/personnel_register.html
	cp ./final_personnel_page.html /Volumes/WL-SL/Webpage/personnel_register.html
	@echo "remove webpage Personnel_register.html from server and replace it"
	@echo "=============================================================="
	@echo "==============Personnel UPDATED IN WEBPAGE===================="
	@echo "=============================================================="

