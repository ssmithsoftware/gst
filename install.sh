#!/bin/sh

set -e

exe=bin/gst
license=share/licenses/gst/LICENSE
outdir=$HOME/${PREFIX-.local}
tmpdir=$(mktemp -d)
url=https://raw.githubusercontent.com/ssmithsoftware/gst/refs/heads/master

curl --output-dir $tmpdir -ZO $url/$exe -O $url/$license

install -Dvm755 $tmpdir/gst $outdir/$exe
install -Dvm644 $tmpdir/LICENSE $outdir/$license

rm -fr $tmpdir/
