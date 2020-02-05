require 'json'
require 'open-uri'

class WordsController < ApplicationController
  before_action :new_word_needed, :last_word

  API_TOKEN = "DAW-BCQiRCxAuIThWZppqUehpIq1OFdx"

  def show
    @citations = @word.citations.split(" - ") unless @word.citations.nil?
    @answer = Answer.new
  end

  def new
    @word = Word.new
    create
  end

  def create
    @word.name = new_word[0]["mot"]
    word_to_use = remove_accents(@word.name)
    definition = word_definition(word_to_use)
    if definition.length == 1
      new
    else
      @word.definition = definition[0]["definition"]
    end
    citations = word_citations(word_to_use)
    unless citations.length == 1
      @word.citations = ""
      citations.each { |citation| citation == citations[0] ? @word.citations += citation["citation"] : @word.citations += " - #{citation["citation"]}" }
    end
    @word.day = Date.today
    @word.save
  end

  private

  def last_word
    @word = Word.last
  end

  def new_word_needed
    word = last_word
    return if !word.nil? && word.day == Date.today

    new
  end

  def new_word
    url = "https://api.dicolink.com/v1/mots/motauhasard?avecdef=true&minlong=5&maxlong=-1&verbeconjugue=false&api_key=#{API_TOKEN}"
    word_request = open(url).read
    return JSON.parse(word_request)
  end

  def word_definition(word)
    url = "https://api.dicolink.com/v1/mot/#{word}/definitions?limite=200&api_key=#{API_TOKEN}"
    definition_request = open(url).read
    return JSON.parse(definition_request)
  end

  def word_citations(word)
    url = "https://api.dicolink.com/v1/mot/#{word}/citations?limite=5&api_key=#{API_TOKEN}"
    citations_request = open(url).read
    return JSON.parse(citations_request)
  end

  def remove_accents(word)
    french_accents = {
      ['á','à','â','ä','ã'] => 'a',
      ['Ã','Ä','Â','À'] => 'A',
      ['é','è','ê','ë'] => 'e',
      ['Ë','É','È','Ê'] => 'E',
      ['í','ì','î','ï'] => 'i',
      ['Î','Ì'] => 'I',
      ['ó','ò','ô','ö','õ'] => 'o',
      ['Õ','Ö','Ô','Ò','Ó'] => 'O',
      ['ú','ù','û','ü'] => 'u',
      ['Ú','Û','Ù','Ü'] => 'U',
      ['ç'] => 'c', ['Ç'] => 'C',
      ['ñ'] => 'n', ['Ñ'] => 'N'
    }
    french_accents.each do |accents, letter|
      accents.each do |accent|
        word = word.gsub(accent, letter)
      end
    end
    return word
  end
end
