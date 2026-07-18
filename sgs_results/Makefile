# Makefile

# To run this code, just run 
#       make run-all
# Target to run all scripts in sequence
#

# Mark non-file targets as PHONY
.PHONY: run-all remove-files remove-files_text

# Target to run all scripts in sequence
run-all: remove-files 01_get_paths_sgs_results 02_genrate_html_sgs_results 03_sed_on_html_sgs_results
	@gum style --foreground 212 --bold "Starting SGS Results HTML Pipeline..."
	@gum spin --spinner dot --title "Processing SGS scripts..." -- bash -c \
		"./01_get_paths_sgs_results.sh && ./02_genrate_html_sgs_results.sh && ./03_sed_on_html_sgs_results.sh"
	@$(MAKE) remove-files_text
	@gum style --foreground 46 --border rounded "Pipeline Complete! SGS Data updated on Server."

# Target to remove specific files before starting the scripts
remove-files:
	@rm -f ./output_sgs_results_u1.html ./pdf_list_sgs_results_2026.txt
	@gum log --level info "Cleaning working directory..."

# Targets for each individual script
01_get_paths_sgs_results:
	@chmod +x ./01_get_paths_sgs_results.sh

02_genrate_html_sgs_results:
	@chmod +x ./02_genrate_html_sgs_results.sh

03_sed_on_html_sgs_results:
	@chmod +x ./03_sed_on_html_sgs_results.sh

remove-files_text:
	@gum spin --spinner line --title "Assembling and deploying to server..." -- bash -c "\
		cat ./header_sgs_results_u1_tag.html ../partial-html_body/nav_tag.html \
		./table_tag.html ./output_sgs_results_u1.html ./part2.html > ./sgs_results_u1__catted.html && \
		rm -f ./pdf_list_sgs_results_2026.txt && \
		cp ./sgs_results_u1__catted.html '/Volumes/My Passport for Mac/NEOS/Server Backup/WL-SL/Webpage/sgs_results_u1.html'"
