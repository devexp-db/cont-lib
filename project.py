config = {
    'name': "cont-lib",
    'macros': {
        # All files under '${autoloaddir}' will be sourced automatically right
        # after sourcing the cont-lib.sh.
        'autoloaddir': '$pkgdatadir/autoload',

        # Files named '*.txt' in this directory will be printed to standard
        # output when 'container-usage' is run.
        'contdocdir': '$datadir/cont-docs',

        # All '*.sh' files from 'cont-entry' will be loaded by
        # '${bindir}/container-entry' script.  This is useful to adjust
        # environment of container "globally" - regardless the "major"
        # component(s) of container or future additional "layers" above the
        # container.  The 'cont-entry' script will still be there.
        # For Docker case, maintainers should always set ENTRYPOINT to
        # 'container-entry' script, and users e.g. should always do
        # 'docker exec CONTHASH cont-entry'.
        'contentry': '$datadir/cont-entry',

        # Under 'conthookdir' packagers will install additional shell "hooks"
        # for particular phases of container start-time.  For example, we could
        # have file under path like:
        # ${conthookdir}/cont-layer/postgresql/post-initdb/add-default-user.sh
        # This hook would be sourced right after PostgreSQL database
        # initialization.
        'conthookdir': '$datadir',
        'contlayerhookdir': '$conthookdir/cont-layer',
        'contvolumehookdir': '$conthookdir/cont-volume',

        # Alias go pkgdatadir which is not going to be redefined for dependant
        # projects.
        'contlib': '$pkgdatadir',

        # Shell snippet to be called from Dockerfile
        'docker_container_build': 'container-build && rm /usr/bin/container-build'
    }
}
