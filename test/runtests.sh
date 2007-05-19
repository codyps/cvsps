#!/bin/sh

CVSROOT="$PWD/repo"
export CVSROOT

if [ ! -d "$CVSROOT" ]; then
    echo "$CVSROOT should be a CVS repository."
    echo "Have you run maketestrepo.sh?"
    exit
fi

if [ ! -x ../cvsps ]; then
    echo "../cvsps needs to exist before it can be tested."
    exit
fi

CVSMODULE=wd
CVSPSFLAGS="--cvs-direct -q"
DIFFFLAGS="-u -a"
CVSPSFILTER="
    s/^Date: */Date: DATESTAMP/
    s/^Author: .*/Author: AUTHOR/
    "
CVSPSCACHEFILTER="
    s/^cache date: */cache date: DATESTAMP/
    s/^date: .*/date: DATESTAMP/
    s/^author: .*/author: AUTHOR/
    "

# Test 1: Can we produce sensible output without the cache
EXPECTED="$PWD/test1.output"
ACTUAL=`mktemp`
../cvsps -x $CVSPSFLAGS $CVSMODULE | sed -e "$CVSPSFILTER" > "$ACTUAL" || exit

diff $DIFFFLAGS "$EXPECTED" "$ACTUAL" || exit

# Test 2: Do we produce a sensible cache file?
EXPECTED="$PWD/test2.cache"
RAWCACHE=`mktemp`
ACTUAL=`mktemp`
../cvsps -x -c "$RAWCACHE" $CVSPSFLAGS $CVSMODULE > /dev/null 
sed -e "$CVSPSCACHEFILTER" "$RAWCACHE" > "$ACTUAL" || exit

diff $DIFFFLAGS "$EXPECTED" "$ACTUAL" || exit

# Test 3: Can we read the cache file we produce?
../cvsps -c "$RAWCACHE" $CVSPSFLAGS $CVSMODULE > /dev/null || exit

# Test 4: Do we produce the same output by reading the cache as we did
# originally?
EXPECTED="$PWD/test1.output"
ACTUAL=`mktemp`
../cvsps -c "$RAWCACHE" $CVSPSFLAGS $CVSMODULE | sed -e "$CVSPSFILTER" > "$ACTUAL" || exit

diff $DIFFFLAGS "$EXPECTED" "$ACTUAL" || exit

echo "Tests passed."
