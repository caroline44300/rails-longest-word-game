require 'json'
require 'open-uri'

class GamesController < ApplicationController
  ALPHABET = ('A'..'Z').to_a

  def new
    @letters = ALPHABET.sample(10)
  end

  def score
    upcase_word = params[:word].upcase
    word_array = upcase_word.split

    letters = params[:letters_list].split

    if !in_the_grid?(word_array, letters)
      @result = "Sorry but #{upcase_word} can't be build out of #{params[:letters_list]}"
    end

    if english?(upcase_word)
      @result = "Congratulation! #{upcase_word} is a valid English word!"
    else
      @result = "Sorry but #{upcase_word} doesn't seem to be a valid English word..."
    end
  end

  private

  def english?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    dictionnary = open(url).read
    check_word = JSON.parse(dictionnary)
    check_word["found"]
  end

  def in_the_grid?(word_array, letters_array)
    # check that the word doesn't use other letters
    word_array.each do |letter|
      index_letter = letters_array.index(letter)
      if index_letter
        letters_array.delete_at(index_letter)
      else
        return false
      end
    end
    true
  end

end
