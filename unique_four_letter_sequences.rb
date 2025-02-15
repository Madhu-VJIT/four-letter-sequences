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

require 'set'
require 'minitest/autorun' if ARGV.include?("test")

# Main functionality encapsulated in a class
class UniqueFourLetterSequences
  attr_reader :occurrences

  def initialize
    # Mapping from sequence (String) to Set of words (Set)
    @occurrences = Hash.new { |h, k| h[k] = Set.new }
    # Mapping to record the first word that yielded the sequence (for later reporting)
    @first_word = {}
  end

  # Process a single word from the dictionary.
  # For each contiguous four-character substring that is all letters,
  # record the (downcased) sequence and the originating word.
  def process_word(word)
    word = word.chomp
    return if word.size < 4
    (0..word.size - 4).each do |i|
      seq = word[i, 4]
      # Only consider sequences made up entirely of letters.
      if seq =~ /\A[A-Za-z]{4}\z/
        seq_down = seq.downcase
        @occurrences[seq_down] << word
        # Save the originating word if this is the first time we see this sequence.
        @first_word[seq_down] ||= word
      end
    end
  end

  # Process all words from a local file.
  def process_file(file_path)
    File.foreach(file_path) do |line|
      process_word(line)
    end
  end

  # Return a hash of unique sequences to their corresponding (first) word.
  # A sequence is unique if it appears in exactly one word.
  def unique_pairs
    unique = {}
    @occurrences.each do |seq, words_set|
      unique[seq] = @first_word[seq] if words_set.size == 1
    end
    unique
  end

  # Write output files: sequences.txt and words.txt.
  # The sequences are sorted alphabetically.
  def write_output(sequence_file = 'sequences.txt', word_file = 'words.txt')
    pairs = unique_pairs
    sorted_sequences = pairs.keys.sort
    File.open(sequence_file, 'w') do |seq_f|
      File.open(word_file, 'w') do |word_f|
        sorted_sequences.each do |seq|
          seq_f.puts seq
          word_f.puts pairs[seq]
        end
      end
    end
  end
end

# Main functionality.
if __FILE__ == $0 && !ARGV.include?("test")
  input_file = 'dictionary.txt'
  unless File.exist?(input_file)
    puts "Error: #{input_file} not found. Please download and save dictionary.txt in the same directory."
    exit 1
  end
  processor = UniqueFourLetterSequences.new
  processor.process_file(input_file)
  processor.write_output
  puts "Output written to sequences.txt and words.txt"
end

# ----------------------
# Unit tests for the program
# ----------------------
if defined?(Minitest)
  class TestUniqueFourLetterSequences < Minitest::Test
    def setup
      @processor = UniqueFourLetterSequences.new
      # Use a sample dictionary (as provided in the problem statement)
      @sample_words = [
        "arrows",
        "18th",
        "carrots",
        "give",
        "me",
        "Isn't",
        "2time"
      ]
      @sample_words.each { |word| @processor.process_word(word) }
    end

    def test_occurrences
      occ = @processor.occurrences
      # "arro" appears in both "arrows" and "carrots", so set size should be 2.
      assert_equal 2, occ["arro"].size
      # "rrow" and "rows" should each come only from "arrows"
      assert_equal Set["arrows"], occ["rrow"]
      assert_equal Set["arrows"], occ["rows"]
      # "carr", "rrot", "rots" come only from "carrots"
      assert_equal Set["carrots"], occ["carr"]
      assert_equal Set["carrots"], occ["rrot"]
      assert_equal Set["carrots"], occ["rots"]
      # "give" comes only from "give"
      assert_equal Set["give"], occ["give"]
      # "time" comes only from "2time"
      assert_equal Set["2time"], occ["time"]
    end

    def test_unique_pairs
      pairs = @processor.unique_pairs
      # "arro" is not unique because it appears in two words.
      refute_includes pairs, "arro"
      # The unique sequences should be: "rrow", "rows", "carr", "rrot", "rots", "give", "time"
      expected = {
        "rrow" => "arrows",
        "rows" => "arrows",
        "carr" => "carrots",
        "rrot" => "carrots",
        "rots" => "carrots",
        "give" => "give",
        "time" => "2time"
      }
      assert_equal expected, pairs
    end

    def test_sorted_output_order
      pairs = @processor.unique_pairs
      sorted_sequences = pairs.keys.sort
      # Expected sorted order is:
      # "carr", "give", "rots", "rows", "rrot", "rrow", "time"
      expected_order = ["carr", "give", "rots", "rows", "rrot", "rrow", "time"]
      assert_equal expected_order, sorted_sequences
    end
  end
end
