# four-letter-sequences

#!/usr/bin/env ruby
# unique_four_letter_sequences.rb
#
# README:
# This Ruby script extracts unique four-letter sequences from words in a
# dictionary file read locally from a file named "dictionary.txt".
#
# Usage:
#   1. Download the dictionary file from:
#      https://gist.github.com/seanbiganski/8c657690b75a830e28557480690bb437
#      and save it as "dictionary.txt" in the same directory as this script.
#   2. Run the script:
#         ruby unique_four_letter_sequences.rb
#
# The script produces two output files:
#   - sequences.txt: Contains the unique four-letter sequences (only letters)
#     that appear in exactly one word.
#   - words.txt: Contains the corresponding word for each sequence, in the same order.
#
# Example:
#
# Given the dictionary file with:
#   arrows
#   18th
#   carrots
#   give
#   me
#   Isn't
#   2time
#
# The output files will be:
#
# sequences.txt         words.txt
# ------------------      ----------------
# carr                  carrots
# give                  give
# rots                  carrots
# rows                  arrows
# rrot                  carrots
# rrow                  arrows
# time                  2time