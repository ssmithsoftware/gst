#!/bin/sh

set -e

prefix=${PREFIX-$HOME/.local}
bindir=$prefix/bin
licdir=$prefix/share/licenses/gst
tmpdir=$(mktemp -d)
url=https://ssmithsoftware.github.io/gst

curl --output-dir $tmpdir -Zso gst $url/src/gst.sh -O $url/LICENSE

mkdir -p -- "$bindir"/ "$licdir"/

cp -i -- $tmpdir/gst "$bindir/"
chmod -- 755 "$bindir/gst"

cp -i -- $tmpdir/LICENSE "$licdir/"
chmod -- 644 "$licdir/LICENSE"

case :$PATH: in
  *:$prefix/bin:*) ;;
  *) echo "$bindir not found in PATH";;
esac

trap "rm -fr $tmpdir/" EXIT
