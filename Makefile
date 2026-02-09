# Root Makefile

# Run ```make ``` in terminal and it will create all the output html 
# pages needed.

# Define each subdirectory
SUBDIRS = roo_sqb html_roo_final_report html_sls_certifcate html_coc \
html_pce_ms html_asset_register html_peronnel_certification \
work_approval main_page sgs_results ims_sop soc_approval roo_sop

# Default target to build all subdirectories
all: $(SUBDIRS)

# Loop over each subdirectory and run its Makefile
$(SUBDIRS):
	$(MAKE) -C $@


# Clean target for each subdirectory if you have clean rules in each Makefile
clean:
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done

.PHONY: all clean $(SUBDIRS)
