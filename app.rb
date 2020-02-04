# app server for hangman
# erb :<action> will execute code in the file views/<action>

require 'sinatra/base'
require 'sinatra/flash'
require './lib/hangperson_game.rb'

class HangpersonApp < Sinatra::Base
  # enables use of the hash "session"
  # session is basically the cookies; anything in this hash is preserved across requests
  enable :sessions

  # enables use of the hash "flash"
  # used for remembering short messages that persist until the very next request, and then are erased
  register Sinatra::Flash
  
  before do
    @game = session[:game] || HangpersonGame.new('')
  end
  
  after do
    session[:game] = @game
  end
  
  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end
  
  get '/new' do
    erb :new
  end
  
  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || HangpersonGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = HangpersonGame.new(word)
    redirect '/show'
  end
  
  post '/guess' do
    # params is a hash containing inputs from the page
    letter = params[:guess].to_s[0]

    begin
      flash[:message] = "You have already used that letter" unless @game.guess(letter)
    rescue ArgumentError
      flash[:message] = "Invalid guess."
    end

    redirect '/show'
  end
  
  # Everytime a guess is made, we should eventually end up at this route.
  # Use existing methods in HangpersonGame to check if player has
  # won, lost, or neither, and take the appropriate action.
  # Notice that the show.erb template expects to use the instance variables
  # wrong_guesses and word_with_guesses from @game.
  get '/show' do
    case @game.check_win_or_lose
    when :win
      redirect '/win'
    when :lose
      redirect '/lose'
    end
    erb :show
  end
  
  get '/win' do
    if @game.check_win_or_lose == :win
      flash[:message] = "You Win!"
      erb :win
    else 
      redirect '/show'
    end
  end
  
  get '/lose' do
    if @game.check_win_or_lose == :lose
      flash[:message] = "Sorry, you lose!"
      erb :lose
    else 
      redirect '/show'
    end
  end
  
end
