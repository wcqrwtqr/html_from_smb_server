# Makefile

# To run this code, just run 
#       make run-all
# Target to run all scripts in sequence
#

# Mark non-file targets as PHONY
.PHONY: run-all remove-files remove-files_text

# Target to run all scripts in sequence
run-all: remove-files 01_get_paths_sgs_results 02_genrate_html_sgs_results 03_sed_on_html_sgs_results
	@echo "Running all scripts in sequence..."
	./01_get_paths_sgs_results.sh
	./02_genrate_html_sgs_results.sh
	./03_sed_on_html_sgs_results.sh
	@echo "All scripts completed."
	$(MAKE) remove-files_text  # Call remove-files_text after scripts

# Target to remove specific files before starting the scripts
remove-files:
	rm -f ./output_sgs_results_u1.html ./pdf_list_sgs_results_u1.txt
	@echo "Removed txt and html files"

# Targets for each individual script
01_get_paths_sgs_results:
	chmod +x ./01_get_paths_sgs_results.sh

02_genrate_html_sgs_results:
	chmod +x ./02_genrate_html_sgs_results.sh

03_sed_on_html_sgs_results:
	chmod +x ./03_sed_on_html_sgs_results.sh

# Target to remove specific files before starting the scripts
remove-files_text:
	cat ./header_sgs_results_u1_tag.html ../partial-html_body/nav_tag.html ./table_tag.html \
	./output_sgs_results_u1.html ../partial-html_body/part2.html > ./sgs_results_u1__catted.html

	rm -f ./pdf_list_sgs_results_u1.txt 
	@echo "Removed pdf_list_sgs_results_u1.txt after finish"

	rm -f /Volumes/WL-SL/Webpage/sgs_results_u1.html
	cp ./sgs_results_u1__catted.html /Volumes/WL-SL/Webpage/sgs_results_u1.html
	@echo "remove webpage all-certificate.html from server and replace it"
	@echo "=============================================================="
	@echo "===============MS sheet UPDATED IN WEBPAGE===================="
	@echo "=============================================================="

