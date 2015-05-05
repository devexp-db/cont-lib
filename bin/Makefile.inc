entry		= %D%/cont-entry
entry_in	= %D%/entry.in

help		= %D%/cont-help
help_in	= %D%/help.in

GENERATED_FILES += \
	$(entry) \
	$(help)

EXTRA_DIST += \
	$(entry_in) \
	$(help_in)

$(entry): $(entry_in) $(text_tpl_deps)
	$(text_tpl_gen_script)

$(help): $(help_in) $(text_tpl_deps)
	$(text_tpl_gen_script)

bin_SCRIPTS += \
	$(entry) \
	$(help)

# vim: ft=automake noet
