require 'yaml'
class Hangman
  # Download the google-10000-english-no-swears.txt dictionary file from the first20hours GitHub repository google-10000-english.
  # When a new game is started, your script should load in the dictionary and randomly select a word between 5 and 12 characters long for the secret word.
  # You don’t need to draw an actual stick figure (though you can if you want to!), but do display some sort of count so the player knows how many more incorrect guesses they have before the game ends. You should also display which correct letters have already been chosen (and their position in the word, e.g. _ r o g r a _ _ i n g) and which incorrect letters have already been chosen.
  # Every turn, allow the player to make a guess of a letter. It should be case insensitive. Update the display to reflect whether the letter was correct or incorrect. If out of guesses, the player should lose.
  # Now implement the functionality where, at the start of any turn, instead of making a guess the player should also have the option to save the game. Remember what you learned about serializing objects… you can serialize your game class too!
  # When the program first loads, add in an option that allows you to open one of your saved games, which should jump you exactly back to where you were when you saved. Play on!

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
    @saved_game = YAML.dump(self)
    puts 'Game saved!'
  end

  def load_game
    puts 'Game loaded!'
    Hangman.new(YAML.load(@saved_game))
  end
end
game = Hangman.new
game.play
