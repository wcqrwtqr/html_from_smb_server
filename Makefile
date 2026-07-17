# Root Makefile

# Run ```make ``` in terminal and it will create all the output html 
# pages needed.

# Define each subdirectory
SUBDIRS = roo_sqb html_roo_final_report html_sls_certifcate sgs_results \
hse_sop html_coc html_pce_ms html_peronnel_certification html_personnel_register \
roo_sop ims_sop work_approval html_asset_register main_page form_qhse form_wl-sl \
soc_approval oem_manual  

# Default target to build all subdirectories
all: $(SUBDIRS) ## Runa all make command in mentioned folders

# Loop over each subdirectory and run its Makefile
$(SUBDIRS):
	$(MAKE) -C $@


# Clean target for each subdirectory if you have clean rules in each Makefile
clean:
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done

.PHONY: all clean $(SUBDIRS)
