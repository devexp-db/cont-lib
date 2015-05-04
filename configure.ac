# Use the MAJ.MIN[~SUFF].  Note that X.X > X.X~SUFF!
AC_INIT([cont-lib], [0.9~dev], [praiskup@redhat.com])

AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE([-Wall foreign])
AC_CONFIG_FILES([Makefile])
AM_SILENT_RULES([yes])

_AX_TEXT_TPL_INIT

# All files under '${autoloaddir}' will be sourced automatically right after
# sourcing the cont-lib.sh.
_AX_TEXT_TPL_ARG_VAR([autoloaddir], ['${pkgdatadir}/autoload'],
                     [cont-lib.sh autoload dir])

# All '*.sh' files from 'cont-entry' will be loaded by '${bindir}/cont-entry'.
# This is useful to adjust environment of container "globally" - regardless the
# "major" component(s) of container or future additional "layers" above the
# container.  The 'cont-entry' script will still be there.
#
# For Docker case, maintainers should always set ENTRYPOINT to 'cont-entry'
# script, and users e.g. should always do 'docker exec CONTHASH cont-entry'.
_AX_TEXT_TPL_ARG_VAR([contentry], ['${datadir}/cont-entry'],
                     [cont-entry autoload dir])

# Under 'conthookdir' packagers will install additional shell "hooks" for
# particular phases of container start.  For example, we could have path like
# ${conthookdir}/cont-layer/postgresql/post-initdb/add-default-user.sh - this
# hook would be sourced right after DB initialization.
_AX_TEXT_TPL_ARG_VAR([conthookdir], ['${datadir}'],
                     [place for per-package hook directories])

_AX_TEXT_TPL_ARG_VAR([contlayerhookdir], ['${datadir}/cont-layer'],
                     [place for per-package layered hook directories])

_AX_TEXT_TPL_ARG_VAR([contvolumehookdir], ['${datadir}/cont-volume'],
                     [place for per-package volume-mounted hook directories])


# Files named '*.txt' in this directory will be printed to standard output
# when 'cont-help' is run.  Any file put in this directory should be named like
# COMPONENT_NAME.txt.
_AX_TEXT_TPL_ARG_VAR([contdocdir], ['${datadir}/cont-docs'],
                     [container documentation directory])

AC_OUTPUT
