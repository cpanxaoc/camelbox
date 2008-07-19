#!/bin/sh

# simple script to package a directory full of files

# - create a timestamp
# - read in a list of directories
# - create a log file
# - enter a directory
# - read the output directory, verify there's not a file with the same name;
# if so, bump up the version #
# - tar it, lzma it, command output to log, file output to user's output
# directory
# - next directory
# - no errors? delete logfile
