require 'json'
require 'open-uri'

class WordsController < ApplicationController
  before_action :new_word_needed, :last_word

  API_TOKEN = "DAW-BCQiRCxAuIThWZppqUehpIq1OFdx"

  def show
    @citations = @word.citations.split(" - ")
    @answer = Answer.new
  end

  def new
    @word = Word.new
    create
  end

  def create
    @word.name = new_word[0].mot
    @word.definition = word_definition(word)[0].definition
    @word.citations = word_citations(word)[0].citation + " - " + word_citations(word)[1].citation + " - " + word_citations(word)[2].citation + " - " + word_citations(word)[3].citation + " - " + word_citations(word)[4].citation
    @word.save
    redirect_to :show
  end

  private

  def last_word
    @word = Word.last
  end

  def new_word_needed
    word = last_word
    return if word.day == Date.today

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
end
