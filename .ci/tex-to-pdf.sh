#!/bin/bash
set -euo pipefail

OUTPUT_FILE=$1
OUTPUT_PREFIX=tmp_$1

# Apply custom styling to DocBook
dblatex -T db2latex $OUTPUT_PREFIX.xml -t tex --texstyle=./manual.sty -p custom.xsl

# Go through the generated .tex output, find the place where the preamble ends
# (marked by the \mainmatter command) and create a file without it.
cat $OUTPUT_PREFIX.tex | awk 'f;/\\mainmatter/{f=1}'  > $OUTPUT_PREFIX"_without_preamble.tex"
# Concat the standardized preamble with the "without_preamble" version of the file
cat preamble.tex $OUTPUT_PREFIX"_without_preamble.tex" > $OUTPUT_PREFIX.tex
texliveonfly $OUTPUT_PREFIX.tex
pdflatex $OUTPUT_PREFIX.tex
pdflatex $OUTPUT_PREFIX.tex

cp $OUTPUT_PREFIX.pdf $OUTPUT_FILE.pdf
cp $OUTPUT_PREFIX.html $OUTPUT_FILE.html
