require 'yaml'
class Hangman
  attr_accessor :word, :guesses, :incorrect_guesses, :correct_guesses, :saved_game

  def initialize
    @dictionary = File.readlines('google-10000-english-no-swears.txt').select do |word|
      word.length.between?(5, 12)
    end
    @word = @dictionary.sample.chomp.downcase
    @guesses = 10
    @incorrect_guesses = []
    @correct_guesses = []
    @saved_game = false
  end

  def play
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
    puts 'Game saved!'
  end

  def load_game
    puts 'Game loaded!'
    Hangman.new(YAML.load(@saved_game))
  end
end
game = Hangman.new
game.play
