require 'RMagick'

class ImageController < ApplicationController

  def index
  end

  def img
    text = REDIS.get(ip + ':text')
    color = REDIS.get(ip + ':color')
    color = 'white' unless color
    unless text
      text = ' '
      REDIS.set(ip + ':text', text)
    end
    img = Magick::Image.new(500, 250) do
      self.background_color = color
    end
    draw = Magick::Draw.new
    draw.annotate(img, 0, 0, 18, 30, "Write text:\n~~~~~~~~") do
      self.font_family = "Consolas"
      self.pointsize = 18
    end
    wrapped = line_wrap text, 40
    unless wrapped.strip.empty?
      draw.annotate(img, 0, 0, 18, 60, "#{line_wrap(text, 40)}") do
        self.pointsize = 12
      end
    end
    img.format = 'png'
    send_data img.to_blob, filename: 'text.png', disposition: 'inline', type: 'image/png'
  end

  def color
    color = params[:c]
    color = 'white' unless %w(red green blue yellow white).include?(color)
    REDIS.set(ip + ':color', color)
    redirect_to REDIRECT_URL
  end

  def add
    if params[:l]
      letter = params[:l]
      letter = letter.slice(0, 1)
    else
      letter = ''
    end
    letter = '' unless (letter =~ /[A-Za-z]/) == 0
    REDIS.append(ip + ':text', letter)
    redirect_to REDIRECT_URL
  end

  def space
    REDIS.append(ip + ':text', ' ')
    redirect_to REDIRECT_URL
  end

  def back
    text = REDIS.get(ip + ':text')
    text = text ? text[0..-2] : ''
    REDIS.set(ip + ':text', text)
    redirect_to REDIRECT_URL
  end

  def clear
    REDIS.set(ip + ':text', '')
    redirect_to REDIRECT_URL
  end

  def ip
    request.remote_ip
  end

  def line_wrap(text, max_cols)
    text.scan(/\S.{0,#{max_cols}}\S(?=\s|$)|\S+/).join("\n")
  end

  def letter?(lookAhead)
    lookAhead =~ /[[:alpha:]]/
  end
end
