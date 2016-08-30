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

default_distro=fedora-23-x86_64
ifndef distro
    distro = $(default_distro)
endif

ifndef docker_main_tag_check
    docker_main_tag_check=false
endif

ifndef docker_main_tag
    docker_main_tag = <THIS_IMAGE>
endif
docker_default_main_tag = <THIS_IMAGE>

ifndef docker_main_tag_hint
    docker_main_tag_hint = \
	echo ; \
	echo " !! Use 'make docker_main_tag=IMAGE_TAG' !!" ; \
	echo
endif

DG = dg

distgen_dg = \
	_gen() { \
	    distro=$(distro) ; \
	    mkdir -p $$(dirname $@) || return 1 ; \
	    test -z "$$distro" && distro=$(distro) ; \
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
	test -z "$$distro" && disto=$(distro) ; \
	dg --output $@ \
	   --distro "$(distro).yaml" \
	   --macros-from "$(cont_lib_dir)" \
	   --macro "docker_main_tag $(docker_main_tag)" \
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
	@if $(docker_main_tag_check); then \
	  if test "$(docker_default_main_tag)" = "$(docker_main_tag)"; then \
	    $(docker_main_tag_hint) ; \
	    false ; \
	  fi ; \
	fi
	@$(MAKE) --no-print-directory all_pre_hook
	@$(MAKE) --no-print-directory all
	@$(MAKE) --no-print-directory all_post_hook

CLEANFILES = $(DESTDIR) $(auto_rules) $(macros_mk)

clean:
	rm -rf $(CLEANFILES)
