# The url that the viewer will be redirected to
# after modifiying text
path = Rails.root.join('config', 'redirect.txt')
if File.exists? path
  REDIRECT_URL = File.open(path).read.gsub("\n", "")
  puts 'using ' + REDIRECT_URL + ' as redirect url'
elsif ENV['IMG_REDIRECT_URL']
  REDIRECT_URL = ENV['IMG_REDIRECT_URL']
else
  # The default redirect goes back to the image
  puts 'redirect.txt file not found - using /img for redirect url'
  REDIRECT_URL = '/img'
end
