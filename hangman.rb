require 'yaml'
class Hangman
  attr_accessor :word, :guesses, :incorrect_guesses, :correct_guesses, :saved_game

  def initialize
    @word = random_word
    @guesses = 10
    @incorrect_guesses = []
    @correct_guesses = []
    @saved_game = false
  end

  def random_word
    dictionary = File.readlines('google-10000-english-no-swears.txt').select do |word|
      word.length > 5 && word.length < 12
    end
    dictionary.sample.chomp.downcase
  end

  def play
    puts 'Welcome to Hangman!'
    puts 'Type save or load to load or save a game'
    until @guesses == 0 || @word == @correct_guesses.join
      display_board
      make_guess
    end
    display_board
    puts "You lose! The word was #{@word}"
  end

  def display_board
    puts "Word: #{@word.split('').map { |letter| @correct_guesses.include?(letter) ? letter : '_' }.join(' ')}"
    puts "Incorrect Guesses: #{@incorrect_guesses.join(' ')}"
    puts "Guesses left: #{@guesses}"
  end

  def make_guess
    puts 'Guess a letter'
    guess = gets.chomp.downcase
    if guess == @word
      puts 'You win!'
      exit
    elsif @word.include?(guess)
      @correct_guesses << guess
    elsif guess == 'save'
      save_game
    elsif guess == 'load'
      load_game
    elsif guess == 'quit'
      exit
    else
      @incorrect_guesses << guess
      @guesses -= 1
    end
  end

  def save_game
    File.open('saved_game.yml', 'w') do |file|
      file.write(YAML.dump(self))
    end
    @saved_game = 'saved_game.yml'
    puts 'Game saved!'
  end

  def load_game
    File.open('saved_game.yml', 'r') do |file|
      @saved_game = YAML.load(file)
    end
    puts 'Game loaded!'
  end
end
game = Hangman.new
game.play
