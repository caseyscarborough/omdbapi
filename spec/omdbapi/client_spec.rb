require 'spec_helper'

describe OMDB::Client do
  it 'should include HTTParty' do
    OMDB::Client.should include(HTTParty)
  end

  it 'should have the correct API endpoint' do
    OMDB::Client.base_uri.should eq(OMDB::Default::API_ENDPOINT)
  end

  describe 'methods' do
    describe 'title' do
      describe 'with a movie that exists' do
        before(:all) do
          VCR.use_cassette('title/valid') do
            @title = OMDB.title('Star Wars')
          end
        end

        it 'should return a hash of movie attributes' do
          @title.should be_instance_of Hash
        end

        it 'should contain a title' do
          @title.title.should be_instance_of String
        end
      end

      describe 'with the year parameter' do
        it 'should not be the same title' do
          VCR.use_cassette('title/year') do
            title1 = OMDB.title('True Grit')
            title2 = OMDB.title('True Grit', year: '1969')
            title1.should_not eq(title2)
          end
        end
      end

      describe 'with the plot parameter' do
        it 'should have different plots' do
          VCR.use_cassette('title/plot') do
            title1 = OMDB.title('Game of Thrones')
            title2 = OMDB.title('Game of Thrones', plot: 'full')
            title1.plot.should_not eq(title2.plot)
          end
        end
      end

      describe 'with the season and episode parameters' do
        it 'should include season and episode in the response' do
          VCR.use_cassette('title/season_and_episode') do
            title = OMDB.title('True Detective', episode: 1, season: 1)
            title.season.should eq('1')
            title.episode.should eq('1')
          end
        end
      end

      describe 'with only the season parameter, missing the episode parameter' do
        it 'should not include episode in the response' do
          VCR.use_cassette('title/season') do
            title = OMDB.title('True Detective', season: 1)
            expect { title.episode }.to raise_error(NoMethodError)
          end
        end
      end

      describe 'with only the episode parameter, missing the season parameter' do
        it 'should not include season and episode in the response' do
          VCR.use_cassette('title/episode') do
            title = OMDB.title('True Detective', episode: 1)
            expect { title.season }.to raise_error(NoMethodError)
            expect { title.episode }.to raise_error(NoMethodError)
          end
        end
      end

      describe "with a movie that doesn't exist" do
        before(:all) do
          VCR.use_cassette('title/nonexistent') do
            @title = OMDB.title('lsdfoweirjrpwef323423dsfkip')
          end
        end

        it 'should return a hash' do
          @title.should be_instance_of Hash
        end

        it 'should return a hash with a false response' do
          @title.response.should eq('False')
        end

        it 'should return a hash with an error message' do
          @title.error.should be_instance_of String
        end
      end
    end

    describe 'id' do
      describe 'with a title that exists' do
        before(:all) do
          VCR.use_cassette('id/existing') do
            @title = OMDB.id('tt0411008')
          end
        end

        it 'should return a hash of movie attributes' do
          @title.should be_instance_of Hash
        end

        it 'should contain a title' do
          @title.title.should be_instance_of String
        end
      end

      describe "with a movie that doesn't exist" do
        before(:all) do
          VCR.use_cassette('id/nonexistent') do
            @title = OMDB.id('tt1231230123')
          end
        end

        it 'should return a hash' do
          @title.should be_instance_of Hash
        end

        it 'should return a hash with a false response' do
          @title.response.should eq('False')
        end

        it 'should return a hash with an error message' do
          @title.error.should be_instance_of String
        end
      end
    end

    describe 'search' do
      describe 'with search results' do
        before(:all) do
          VCR.use_cassette('search/results') do
            @results = OMDB.search('Star Wars')
          end
        end

        it 'should return an array' do
          @results.should be_instance_of Array
        end

        it 'should return an array with hash contents' do
          @results.first.should be_instance_of Hash
        end
      end

      describe 'with a single search result' do
        before(:all) do
          VCR.use_cassette('search/result') do
            @result = OMDB.search('Star Wars Episode IV A New Hope')
          end
        end

        it 'should return a hash of the title' do
          @result.should be_instance_of Hash
        end

        it 'should have a title' do
          @result.title.should eq('Star Wars: Episode IV - A New Hope')
        end
      end

      describe 'with no search results' do
        before(:all) do
          VCR.use_cassette('search/empty') do
            @results = OMDB.search('lsdfoweirjrpwef323423dsfkip')
          end
        end

        it 'should return a hash' do
          @results.should be_instance_of Hash
        end

        it 'should return a hash with a false response' do
          @results.response.should eq('False')
        end

        it 'should return a hash with an error message' do
          @results.error.should be_instance_of String
        end
      end

      describe 'should be aliased to find' do
        it 'should be the same method' do
          VCR.use_cassette('search/find') do
            OMDB.search('Star Wars').should eq(OMDB.find('Star Wars'))
          end
        end
      end
    end
  end
end
