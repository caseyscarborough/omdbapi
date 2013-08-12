module OMDB
  module Default

    API_ENDPOINT = 'http://omdbapi.com'

  end
end

# Monkey patch the Hash class to allow accessing hashes using
# dot notation.
# For instance: hash['key'] => hash.key
class ::Hash
  def method_missing(name)
    return self[name] if key? name
    self.each { |k,v| return v if k.to_s.to_sym == name }
    super.method_missing name
  end
end

# Monkey patch the string class to convert strings from
# camel case to snake case. Is this too much monkey patching?
# For instance: "CamelCasedString".to_snake_case => "camel_cased_string"
class String
  def to_snake_case
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
end