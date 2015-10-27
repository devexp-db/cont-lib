#! /bin/sh

. {{ macros.pkgdatadir }}/cont-lib.sh

opt_component=
opt_topic=HOME

opt_requires_arg ()
{
    _cl_opt=$1 ; shift
    _cl_storage=$1 ; shift

    test $# -gt 0 || cont_fatal "opt $_cl_opt requires argument"

    eval "$_cl_storage=\$1"
}

fatal_with_available_components ()
{
    cont_error "$*"
    if test -n "$components"; then
        cont_error
        cont_error "Available components (with help) are:"
        for i in $components
        do
            cont_error "  $i"
        done
    else
        cont_error "No components for $0 documentation available."
    fi
    exit 1
}

# Gather info about container.

components=
for i in "{{ m.contdocdir }}"/*; do
    component=$(basename "$i")
    test -d "$i" && components="$components $component"
done


# Parse options.

set dummy "$@" -- ; shift
while test $# -gt 0
do
    option=$1 ; shift
    case $option in
    --component)
        opt_requires_arg "$option" opt_component "$@"
        shift
        ;;
    --topic)
        opt_requires_arg "$option" opt_topic "$@"
        shift
        ;;
    --)
        break
        ;;
    --*)
        cont_fatal "unknown option $option"
        ;;
    *)
        # Store for (possible) later usage.
        set dummy "$@" $option
        ;;
    esac
done

test -z "$opt_component" \
    && fatal_with_available_components "No --component specified!"

case " $components " in
    *" $opt_component "*)
        ;;
    *)
        fatal_with_available_components \
            "Invalid component '$opt_component'"
        ;;
esac

file="{{ m.contdocdir }}/$opt_component/$opt_topic.txt"
test -f "$file" \
    && cat "$file" \
    || cont_fatal "help file '$file' not found"
