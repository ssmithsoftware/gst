# gst

```sh
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
```

## install

`curl -o- https://ssmithsoftware.github.io/gst/install.sh | sh`
