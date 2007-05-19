#!/bin/sh

CVSROOT="$PWD/repo"
WORKINGDIR="$PWD/wd"
export CVSROOT

rm -rf "$CVSROOT" "$WORKINGDIR" || exit

# Set up the repository
mkdir -p "$CVSROOT"
cvs init

# Set up the module
mkdir -p "$WORKINGDIR"
(
    cd "$WORKINGDIR"
    cvs import -m "Initial import" wd vendor-tag release-tag
)
rm -rf "$WORKINGDIR"
cvs co wd

# Add a dummy file to the module, with some tags
(
    cd "$WORKINGDIR"

    echo "A test of multiple tags" > tag-testing

    cvs add tag-testing

    cvs commit -m "Initial file"

    cvs tag -c tag1

    cvs tag -c tag2

)
