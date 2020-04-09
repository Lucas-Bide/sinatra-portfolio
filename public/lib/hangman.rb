class Hangman
  attr_reader :mistakes, :guessed_letters, :mistakes, :secret_word

  @@ENTRIES = "abcdefghijklmnopqrstuvwxyz"

  def initialize
    @guessed_letters = []
    @mistakes = 0
    @word_discovered = false
    select_word
  end

  def guess(guess)
    @guessed_letters << guess
    @guessed_letters.sort!

    if @word.include?(guess)
      for char in 0...@word.length
        @secret_word[char] = guess if @word[char] == guess
      end
       @word_discovered = true if !@secret_word.include?("_")   
    else
      @mistakes += 1
    end
  end

  def game_over?
    @word_discovered || mistakes == 6
  end

  def result
    @word_discovered ? "You saved him!" : "He died because of YOU!"
  end

  def valid_guess?(guess)
    guess.length == 1 && @@ENTRIES.include?(guess) && !@guessed_letters.include?(guess)
  end

  private

  def select_word
      options = File.open("public/5desk.txt", "r").read.split().select {|word| word.length >= 5 && word.length <= 12}
      @word = options.sample
      @secret_word = "_" * @word.length
  end
end

