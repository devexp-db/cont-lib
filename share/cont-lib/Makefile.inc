library		= %D%/cont-lib.sh
library_in	= %D%/cont-lib.sh.in

simple_config_parser	= %D%/parser-simple-config.sh
simple_config_parser_in	= %D%/parser-simple-config.sh.in

GENERATED_FILES += \
	$(library) \
	$(simple_config_parser)

EXTRA_DIST += \
	$(library_in) \
	$(simple_config_parser_in)

$(library): $(library_in) $(text_tpl_deps)
	$(text_tpl_gen)

$(simple_config_parser): $(simple_config_parser_in) $(text_tpl_deps)
	$(text_tpl_gen)

pkgdata_DATA = \
	$(library) \
	$(simple_config_parser)
