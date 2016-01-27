first: distgen-all $(full_deps)

ifndef DESTDIR
    DESTDIR = output
endif

ifndef cont_lib_dir
    cont_lib_dir = .
endif

ifndef root_subdir
    root_subdir = /root
endif

macros_mk = macros.mk
-include $(macros_mk)

ifndef auto_rules
    auto_rules = auto-rules.mk $(cont_lib_dir)/auto-rules.mk
endif

make_helper = $(cont_lib_dir)/make-helper.sh

default_distro=fedora-22-x86_64

DG = dg

distgen_dg = \
	_gen() { \
	    distro=$(distro) ; \
	    mkdir -p $$(dirname $@) || return 1 ; \
	    test -z "$$distro" && distro=$(default_distro) ; \
	    echo "  DG       $@" ; \
	    $(DG) --output "$@" \
	       --distro "$$distro.yaml" \
	       --container docker \
	       --macros-from "$(cont_lib_dir)" \
	       $$@ || return 1 ; \
	    chmod 644 "$@" ; \
	} ; \
	_gen

distgen_cp = \
	echo "  CP       $@" ; \
	mkdir -p $$(dirname $@) && cp $< $@

$(static_files): root%: tpl%
	@echo "  CP       $@"
	@mkdir -p $$(dirname $@) && cp $< $@

copystatic: $(static_files)

.PHONY: autorules

$(auto_rules): %auto-rules.mk: %cl-manifest $(make_helper)
	@dir=$(shell echo $$(dirname $<)) ; $(auto_rules_generator)

$(macros_mk): project.py $(cont_lib_dir)/project.py
	@echo "  GEN      $@" ; \
	distro="$(distro)" ; \
	test -z "$$distro" && disto=$(default_distro) ; \
	dg --output $@ \
	   --distro "$(default_distro).yaml" \
	   --macros-from "$(cont_lib_dir)" \
	   --template makefile-macros.tpl

auto_rules_generator = \
	echo "  GEN      $@" ; \
	$(make_helper) \
	    --srcdir=$$dir --deps --spec $< > $@.tmp && \
	    mv $@.tmp $@

auto_rules_detector = \
	test -f $$dir/auto-rules.mk \
	&& echo $$dir/auto-rules.mk

full_deps = $(DESTDIR)$(root_subdir)$(bindir)/container-build

$(DESTDIR)$(root_subdir)$(bindir)/container-build: $(auto_rules)
	@echo "  GEN      $@" ; \
	mkdir -p $$(dirname $@) || exit 1 ; \
	_f() { \
	  echo 'set -x' ; \
	  $(build_content) \
	  echo "$(docker_set_default_cmd)" ; \
	} ; _f > $@ && chmod +x $@

build_content =

-include $(auto_rules)

.PHONY: all all_pre_hook all_post_hook
all: $(full_deps)
all_pre_hook: $(all_pre_hooks)
all_post_hook: $(all_post_hooks) $(full_deps)

distgen-all: $(auto_rules) $(macros_mk)
	@$(MAKE) --no-print-directory all_pre_hook
	@$(MAKE) --no-print-directory all
	@$(MAKE) --no-print-directory all_post_hook

CLEANFILES = $(DESTDIR) $(auto_rules) $(macros_mk)

clean:
	rm -rf $(CLEANFILES)
