library		= %D%/cont-lib.sh
library_in	= %D%/$(srcdir)/cont-lib.sh.in

GENERATED_FILES += \
	$(library)

EXTRA_DIST += \
	$(library_in)

$(library): $(library_in) $(text_tpl_deps)
	$(text_tpl_gen)


pkgdata_DATA = \
	$(library)
