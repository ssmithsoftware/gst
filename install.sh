#!/bin/sh

set -e

prefix=${PREFIX-$HOME/.local}
bindir=$prefix/bin
licdir=$prefix/share/licenses/gst
tmpdir=$(mktemp -d)
url=https://ssmithsoftware.github.io/gst

curl --output-dir $tmpdir -Zo gst $url/src/gst.sh -O $url/LICENSE

mkdir -pv -- "$bindir"/ "$licdir"/

cp -iv -- $tmpdir/gst "$bindir/"
chmod -v -- 755 "$bindir/gst"

cp -iv -- $tmpdir/LICENSE "$licdir/"
chmod -v -- 644 "$licdir/LICENSE"

case :$PATH: in
  *:$prefix/bin:*) ;;
  *) echo "$bindir not found in PATH";;
esac

trap "rm -frv $tmpdir/" EXIT
