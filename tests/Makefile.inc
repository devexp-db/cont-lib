config_parser = %D%/config_parser.sh
config_parser_in = %D%/config_parser.sh.in

EXTRA_DIST += \
	$(config_parser_in)

$(config_parser): $(config_parser_in) $(text_tpl_deps)
	$(text_tpl_gen_script)

CHECK_DEPS = $(config_parser)

check-local: $(CHECK_DEPS)
	@for i in $(CHECK_DEPS); do \
	    id=$${i%%.sh} ; \
	    echo " => testing $$i" ; \
	    $$i > $$id.out && \
	    diff $$id.out $$id.exp || exit 1 ; \
	done

# vim: ft=automake noet
