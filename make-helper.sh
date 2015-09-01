#!/bin/bash

opt_spec=
opt_mode=
opt_srcdir=.
opt_destdir="\$(DESTDIR)"

nl='
'

die()
{
    echo " # $*" >&2
    exit 1
}

dbg()
{
    echo " ~ $*" >&2
}

warn()
{
    echo " ! $*" >&2
}

set_mode()
{
    test -n "$opt_mode" \
        && test "$opt_mode" != "$1" \
        && die "mode already set to '$opt_mode'"
    opt_mode=$1
}

ARGS=$(getopt -o "" -l "deps,test,spec:,srcdir:,destdir:" -n "$0" -- "$@") \
    || exit 1
eval set -- "$ARGS"

while :
do
    case "$1" in
        --deps)
            set_mode deps
            shift
            ;;
        --test)
            set_mode test
            shift
            ;;
        --srcdir|--destdir)
            eval opt_"${1##--}"=\$2
            shift 2
            ;;
        --spec)
            opt_spec=$2
            shift 2
            ;;
        --)
            shift
            break
            ;;
    esac
done

build_content="build_content += "
full_deps="full_deps +="

full_deps_add()
{
    full_deps="$full_deps \\
	$1"
}


args_prefilter()
{
    # args_DG target options
    local function="$1"
    shift

    local target="$1"
    shift

    local is_rooted=false

    local ARGS=()

    set -- "$@" --END--
    while true
    do
        case "$1" in
            --END--)
                break
                ;;

            outputroot)
                is_rooted=:
                break
                ;;

            chmod=*)
                local opt=${1##*=}
                build_content+="\\
	echo chmod $opt $target ;"
                shift
                ;;
            *)
                ARGS+=("$1")
                shift
                ;;
        esac
    done

    if $is_rooted; then
        target="$opt_destdir$target"
    else
        target="$opt_destdir\$(root_subdir)$target"
    fi

    full_deps_add "$target"

    "$function" "$target" "${ARGS[@]}"
}

args_DG()
{
    local target="$1"

    local fin_deps=""
    local fin_cmd="@\$(distgen_dg)"

    local template=
    local spec=
    local tpl=
    local gtpl=

    shift 1

    while test $# -gt 0; do
        case "$1" in
            spec=*|gtpl=*|tpl=*)
                local opt=${1%%=*}
                local val=${1##*=} ; : "$val" # silence shellcheck

                eval test -n "\$$opt" \
                    || die "multiple $opt =$spec="

                eval "$opt=\$val"

                if test tpl = "$opt" || test gtpl = "$opt"; then
                    test -n "$template" && \
                        die "already set template '$template' for '$target' (new '$val')"
                    eval template="$val"
                fi

                ;;

            gtpl=*)
                tpl="${1##tpl=}"
                ;;
            *)
                warn "unknown option '$1'"
                ;;
        esac
        shift
    done

    if test -n "$tpl"; then
        fin_cmd+=" --template $opt_srcdir/$tpl"
        fin_deps+=" $opt_srcdir/$tpl"
    elif test -n "$gtpl"; then
        fin_cmd+=" --template $gtpl"
    else
        die "no template set for '$target'"
    fi

    fin_cmd+=" --projectdir $opt_srcdir"

    test -f "$opt_srcdir/project.py" \
        && fin_deps+=" $opt_srcdir/project.py"

    if test -n "$spec"; then
        fin_cmd+=" --spec $opt_srcdir/$spec"
        fin_deps+=" $opt_srcdir/$spec"
    fi

    cat <<EOF
$target: $fin_deps
	$fin_cmd$nl
EOF
}

args_CP()
{
    local target="$1"
    cat <<EOF
$target: $opt_srcdir/$2
	@\$(distgen_cp)$nl
EOF
}


handle_deps_line()
{
    local action="$1"
    shift
    case "$action" in
        CP|DG)
            args_prefilter args_"$action" "$@"
            ;;
    esac
}

while read line; do
    # TODO: work on better escaping!
    line=${line//\(/\\\(}
    line=${line//\)/\\\)}
    eval set -- "$line"

    case $opt_mode in
        deps)
            handle_deps_line "$@"
            ;;
    esac
done < "$opt_spec"

case $opt_mode in
    deps)
        echo "$full_deps"
        echo
        echo "$build_content"
        ;;
esac
