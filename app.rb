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
  
  # default uri, redirects to new
  get '/' do
    redirect '/new'
  end
  
  # displays page with button to start a new game
  get '/new' do
    erb :new
  end
  
  # creates a new game by generating a random word and passing it into the game
  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || HangpersonGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = HangpersonGame.new(word)
    redirect '/show'
  end
  
  # processes a player's guess
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
  
  # displays page with status for game
  # also has form to allow player to guess
  # redirects if player wins or loses
  get '/show' do
    case @game.check_win_or_lose
    when :win
      redirect '/win'
    when :lose
      redirect '/lose'
    end
    erb :show
  end
  
  # displays page for winning
  # redirects to show if player tries to cheat by altering uri
  get '/win' do
    if @game.check_win_or_lose == :win
      flash[:message] = "You Win!"
      erb :win
    else 
      redirect '/show'
    end
  end
  
  # displays page for losing
  # redirects to show if player tries to cheat by altering uri
  get '/lose' do
    if @game.check_win_or_lose == :lose
      flash[:message] = "Sorry, you lose!"
      erb :lose
    else 
      redirect '/show'
    end
  end
  
end
