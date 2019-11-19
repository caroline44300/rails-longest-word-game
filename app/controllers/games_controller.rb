require 'json'
require 'open-uri'

class GamesController < ApplicationController
  ALPHABET = ('A'..'Z').to_a

  def new
    @letters = ALPHABET.sample(10)
  end

  def score
    @upcase_word = params[:word].upcase

    @letters = params[:letters_list].split

    if english?(@upcase_word)
      @result = "Congratulation! #{@upcase_word} is a valid English word!"
    else
      @result = "Sorry but #{@upcase_word} doesn't seem to be a valid English word..."
    end

    unless in_the_grid?(@upcase_word, @letters)
      @result = "Sorry but #{@upcase_word} can't be build out of #{@letters}"
    end
  end

  private

  def in_the_grid?(word, letters_array)
    # check that the word doesn't use other letters
    word.split.each do |letter|
      index_letter = letters_array.index(letter)
      if index_letter
        letters_array.delete_at(index_letter)
      else
        return false
      end
    end
    true
  end

  def english?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    dictionnary = open(url).read
    check_word = JSON.parse(dictionnary)
    check_word['found']
  end
end
