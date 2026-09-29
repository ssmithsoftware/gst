#!/bin/sh

set -e

tmpdir=$(mktemp -d)
usage=$(cat <<EOF
gst is used to tailor the output of go test and go tool cover.

Usage: gst [ -c [ -C -f -H -n -o ] -g -h -v ] [PACKAGE]... [REGEXP]
  -C Flags passed to go tool cover. Expanded by IFS, should be quoted.
  -c Get coverage profile
  -f Get coverage percentages for each function
  -g Flags passed to go test. Expanded by IFS, should be quoted.
  -H Get HTML document from coverage profile
  -h Show usage
  -n Filter coverage profile to nonzero only
  -o Output directory for all files
  -v Verbose output
EOF
)

get_cover () {
  if [ -n "$1" ]; then
    set -- $1 "${outdir-$tmpdir}/cover.out" \
      ${outdir+-o} ${outdir+"$outdir/$2"} \
      $cflags

    go tool cover "$@"
  fi
}

set_cover () {
  if [ -z $cover ]; then
    cover=-coverprofile
  fi
}

while getopts :C:cfg:Hhno:v name
do
  case $name in
    :) printf "-$OPTARG requires an argument\n\n$usage"; exit 2;;
    \?|h) echo "$usage"; exit 2;;
    C) set_cover; cflags=$OPTARG;;
    c) set_cover;;
    f) set_cover; func=-func;;
    g) gflags=$OPTARG;;
    H) set_cover; html=-html;;
    n) set_cover; nonzero=1;;
    o) set_cover; outdir=$OPTARG;;
    v) verbose=-v;;
  esac
done

shift $((OPTIND - 1))

for arg in "$@"; do
  if [ -z $opts ]; then
    set -- $cover ${cover+"${outdir-$tmpdir}/cover.out${nonzero+.tmp}"} \
      $verbose $gflags

    opts=1
  fi

  if go list -find "$arg" >/dev/null 2>&1; then
    set -- "$@" "$arg"
  else
    set -- "$@" -run "$arg"

    break
  fi
done

if [ -n "$outdir" ]; then
  mkdir -p "$outdir"
fi

go test "$@"

if [ -n "$cover" ]; then
  if [ -n "$nonzero" ]; then
    grep -v '0$' "${outdir-$tmpdir}/cover.out.tmp" \
      >"${outdir-$tmpdir}/cover.out"

    rm "${outdir-$tmpdir}/cover.out.tmp"
  fi

  get_cover $func ${func+functions.txt}

  if ! get_cover $html ${html+index.html}; then
    echo 'Failed to open HTML document. No file opener exists.'
  fi
fi

rm -fr $tmpdir/
