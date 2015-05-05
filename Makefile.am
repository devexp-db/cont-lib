bin_SCRIPTS =

GENERATED_FILES =
EXTRA_DIST =

include bin/Makefile.inc

include share/cont-layer/Makefile.inc
include share/cont-lib/Makefile.inc
include share/cont-lib/autoload/Makefile.inc
include share/cont-volume/Makefile.inc
include tests/Makefile.inc

.PHONY: git-test-build
git-test-build:
	./configure --prefix=`pwd`

generate_docker_tarball:
	./configure --prefix=/usr
	make
	rm -rf .inst
	make install DESTDIR=`pwd`/.inst
	tar --owner=root --group=root -czf cont-lib.tar.gz \
	    -C .inst \
	    --no-recursion \
	    -T $(abs_top_srcdir)/.inst-list


CLEANFILES = $(GENERATED_FILES)
