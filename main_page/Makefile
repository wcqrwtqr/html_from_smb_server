# Makefile

# To run this code, just run 
#       make run-all
# Target to run all scripts in sequence
#

# Mark non-file targets as PHONY
.PHONY: run-all remove-files remove-files_text

# Target to run all scripts in sequence
run-all: remove-files 01_get_anlysis_data
	@echo "Running all scripts in sequence..."
	./01_get_anlysis_data.sh
	@echo "All scripts completed."
	$(MAKE) remove-files_text  # Call remove-files_text after scripts

# Target to remove specific files before starting the scripts
remove-files:
	rm -f ./output_roo_sqb.html ./pdf_list_roo_sqb.txt
	@echo "Removed txt and html files"

# Targets for each individual script
01_get_paths:
	chmod +x ./01_get_anlysis_data.sh


# Target to remove specific files before starting the scripts
remove-files_text:
	cat ../partial-html_body/index_header.html ../partial-html_body/nav_tag.html ../partial-html_body/index_footer_a.html ./table_head_tag.html ./table_data.html ../partial-html_body/index_footer_b.html > ./catted_index_analysis.html
	rm -f /Volumes/WL-SL/Webpage/index.html
	@echo "Remove the inex page from webpage folder"
	cp ./catted_index_analysis.html /Volumes/WL-SL/Webpage/index.html
	@echo "Removed the webpage index.html and coppied the updated file in its place"
	@echo "=============================================================="
	@echo "==================Updated index with analysis================="
	@echo "=============================================================="



