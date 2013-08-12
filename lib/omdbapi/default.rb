module OMDB

  # Default configuration options for OMDB.
  module Default

    # Default API endpoint
    API_ENDPOINT = 'http://omdbapi.com'

  end
end

# Reopen the Hash class to add method.
class ::Hash

  # Allow accessing hashes via dot notation.
  #
  # @param name [String] The method name.
  # @return [Object]
  def method_missing(name)
    return self[name] if key? name
    self.each { |k,v| return v if k.to_s.to_sym == name }
    super.method_missing name
  end
end

# Reopen the String class to add to_snake_case method.
class String

  # Convert string to snake case from camel case.
  #
  # @return [String]
  # @example
  #   "CamelCasedString".to_snake_case # => "camel_cased_string"
  def to_snake_case
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
end