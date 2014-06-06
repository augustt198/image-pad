yml = YAML.load_file(Rails.root.join('config', 'redis.yml'))
yml = {} unless yml.is_a? Hash
REDIS = Redis.new(yml.symbolize_keys)
