require 'sinatra'
require_relative 'public/lib/hangman.rb'
require_relative 'public/lib/cipher.rb'

enable :sessions

get '/' do
  session.delete(:hangman) if session[:hangman]
  erb :index
end

get '/hangman' do
  session[:hangman] = Hangman.new unless session[:hangman]
  erb :hangman, locals: {game: session[:hangman], message: session.delete(:message)}
end

post '/hangman' do
  game = session[:hangman]
  guess = params[:guess].downcase if params[:guess]
  if params[:return]
    session.delete(:hangman)
    redirect '/'
  elsif params[:restart]
    session[:hangman] = Hangman.new
    redirect '/hangman'
  elsif game.valid_guess?(guess)
    game.guess(guess)
    session[:message] = game.result if game.game_over?
    redirect '/hangman'
  else
    session[:message] = "Enter a letter that hasn't been guessed yet!"
    erb :hangman, locals: {game: game, message: session.delete(:message)}
  end
end

get '/cipher' do
  phrase = params[:phrase]
  key = params[:key]
  encryption = phrase.nil? ? nil : Cipher.caesar_cipher(phrase, key.to_i)
  erb :cipher, :locals => {phrase: phrase, key: key, encryption: encryption}

end

