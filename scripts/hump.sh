#!/bin/true

# script to run a before/after diff on the camelbox folder, and generate a
# list of files that have been added to the after snapshot

# psuedocode
# - run the find on the camelbox tree
# - the user does their install bits
# - run find on the camelbox tree again
# - diff the two finds
# - (optional) filter out .cpan entries 
