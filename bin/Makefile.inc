entry		= %D%/cont-entry
entry_in	= %D%/entry.in

GENERATED_FILES += \
	$(entry)

EXTRA_DIST += \
	$(entry_in)

$(entry): $(entry_in) $(text_tpl_deps)
	$(text_tpl_gen_script)

bin_SCRIPTS += \
	$(entry)

# vim: ft=automake noet
