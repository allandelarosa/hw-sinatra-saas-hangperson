class HangpersonGame

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses

  def guess letter
    raise ArgumentError.new 'Invalid guess' unless letter =~ /[a-zA-Z]/

    letter = letter.downcase
    if @word.include? letter
      unless @guesses.include? letter
        @guesses += letter 
      else
        return false
      end
    else
      unless @wrong_guesses.include? letter
        @wrong_guesses += letter 
      else
        return false
      end
    end
  end

  def word_with_guesses
    r = @guesses == '' ? '\w' : "[^#{@guesses}]"
    @word.gsub( /#{r}/, '-' )
  end

  def check_win_or_lose
    return :lose if @wrong_guesses.length == 7
    return :win if word_with_guesses == @word
    return :play
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
