path = Rails.root.join('config', 'redis.yml')
if File.exists? path
  yml = YAML.load_file path
elsif ENV['REDISTOGO_URL']
  yml = {'url' => ENV['REDISTOGO_URL']}
end
yml = {} unless yml.is_a? Hash
REDIS = Redis.new(yml.symbolize_keys)
