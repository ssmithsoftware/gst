#!/bin/sh

set -e

usage=$(cat <<EOF
gst is used to tailor the output of go test and go tool cover.

Usage: gst [ -c [ -f -n -o -p -w ] -g -h -v ] [PACKAGE]... [REGEXP]
  -c Get coverage profile
  -f Get coverage percentages for each function
  -g Flags passed to go test. Expanded by IFS, should be quoted.
  -h Show usage
  -n Filter coverage profile to nonzero only
  -o Output directory for all coverage files
  -p Flags passed to go tool cover. Expanded by IFS, should be quoted.
  -v Verbose output
  -w Get HTML document from coverage profile
EOF
)

get_cover () {
  if [ -n "$1" ]; then
    set -- $1 "$outdir/cover.out" $out ${out+"$outdir/$2"} $cflags

    go tool cover "$@"
  fi
}

set_cover () {
  if [ -z $cover ]; then
    cover=-coverprofile
  fi
}

while getopts :cfg:hno:p:vw name
do
  case $name in
    :) printf "-$OPTARG requires an argument\n\n$usage"; exit 2;;
    \?|h) echo "$usage"; exit 2;;
    c) set_cover;;
    f) set_cover; func=-func;;
    g) gflags=$OPTARG;;
    n) set_cover; nonzero=1;;
    o) set_cover; out=-o outdir=$OPTARG;;
    p) set_cover; cflags=$OPTARG;;
    v) verbose=-v;;
    w) set_cover; html=-html;;
  esac
done

if [ -z $out ]; then
  outdir=$(mktemp -d)

  if [ -n "$verbose" ]; then
    echo "$outdir"
  fi
else
  mkdir -p $verbose -- "$outdir"
fi

shift $((OPTIND - 1))

for arg in "$@"; do
  if [ -z $opts ]; then
    set -- $cover ${cover+"$outdir/cover.out${nonzero+.tmp}"} $verbose $gflags

    opts=1
  fi

  if go list -find "$arg" >/dev/null 2>&1; then
    set -- "$@" "$arg"
  else
    set -- "$@" -run "$arg"

    break
  fi
done

go test "$@"

if [ -n "$cover" ]; then
  if [ -n "$nonzero" ]; then
    grep -v '0$' "$outdir/cover.out.tmp" >"$outdir/cover.out"

    rm "$outdir/cover.out.tmp"
  fi

  get_cover $func ${func+func.txt}

  if ! get_cover $html ${html+index.html}; then
    echo 'Failed to open HTML document. No file opener exists.' >&2
  fi
fi
