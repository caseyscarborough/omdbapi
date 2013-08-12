# omdbapi

This gem is (will be) a simple and easy to use wrapper for the [omdbapi.com](http://omdbapi.com/) API.

## Installation

### Requirements

* Ruby v1.9.3 or later

### Installing

You can install the gem by adding it your application's Gemfile:

```ruby
gem 'omdbapi'
```

And then execute:

```bash
$ bundle
```

Or you can install it manually by issuing the following command:

```bash
$ gem install omdbapi
```

## Usage

```ruby
require 'omdbapi'
```
### Title

You can get a movie or TV show's information in a Hash by using the title method, shown below:

```ruby
game_of_thrones = OMDB.title('Game of Thrones')
# => {:title=>"Game of Thrones", :year=>"2011", :rated=>"TV-MA", :released=>"17 Apr 2011", :runtime=>"1 h", :genre=>"Adventure, Drama, Fantasy", :director=>"N/A", :writer=>"David Benioff, D.B. Weiss", :actors=>"Peter Dinklage, Lena Headey, Maisie Williams, Emilia Clarke", :plot=>"Seven noble families fight for control of the mythical land of Westeros.", :poster=>"http://ia.media-imdb.com/images/M/MV5BNTY2MzAxNzM0Ml5BMl5BanBnXkFtZTcwNDA0MDkxOQ@@._V1_SX300.jpg", :imdb_rating=>"9.4", :imdb_votes=>"382,638", :imdb_id=>"tt0944947", :type=>"series", :response=>"True"} 
game_of_thrones.title # => "Game of Thrones"
game_of_thrones.year  # => "2011"
game_of_thrones.rated # => "TV-MA"
# etc...
```

This function will return a Hash with the following information about the title:

```ruby
:title, :year, :rated, :released, :runtime, :genre, :director, :writer, 
:actors, :plot, :poster, :imdb_rating, :imdb_votes, :imdb_id, :type
```

### Search

You can search for a title by using the search method:

```ruby
search = OMDB.search('Star Wars')
# => [{:title=>"Star Wars", :year=>"1977", :imdb_id=>"tt0076759", :type=>"movie"}, {:title=>"Star Wars: Episode V - The Empire Strikes Back", :year=>"1980", :imdb_id=>"tt0080684", :type=>"movie"}, {:title=>"Star Wars: Episode VI - Return of the Jedi", :year=>"1983", :imdb_id=>"tt0086190", :type=>"movie"}, {:title=>"Star Wars: Episode I - The Phantom Menace", :year=>"1999", :imdb_id=>"tt0120915", :type=>"movie"}, {:title=>"Star Wars: Episode III - Revenge of the Sith", :year=>"2005", :imdb_id=>"tt0121766", :type=>"movie"}, {:title=>"Star Wars: Episode II - Attack of the Clones", :year=>"2002", :imdb_id=>"tt0121765", :type=>"movie"}, {:title=>"Star Wars: The Clone Wars", :year=>"2008", :imdb_id=>"tt1185834", :type=>"movie"}, {:title=>"Star Wars: Clone Wars", :year=>"2003", :imdb_id=>"tt0361243", :type=>"series"}, {:title=>"Star Wars: The Clone Wars", :year=>"2008", :imdb_id=>"tt0458290", :type=>"series"}, {:title=>"The Star Wars Holiday Special", :year=>"1978", :imdb_id=>"tt0193524", :type=>"movie"}]
search.each { |result| puts result.title }
# etc...
```

This method returns an Array of search results. Each search result is a Hash with the following information about the result:

```ruby
:title, :year, :imdb_id, :type
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
