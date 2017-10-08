require 'spec_helper'

describe OMDB::Client do
  it 'should include HTTParty' do
    expect(OMDB::Client).to include(HTTParty)
  end

  it 'should have the correct API endpoint' do
    expect(OMDB::Client.base_uri).to eq(OMDB::Default::API_ENDPOINT)
  end

  describe 'api key' do
    it "returns the instance variable if set" do
      OMDB.api_key = 'secret'
      expect(OMDB.api_key).to eq('secret')
    end

    it "returns the the ENV var OMDB_API_KEY if instance variable not set" do
      OMDB.api_key = nil
      expect(ENV).to receive(:[]).with('OMDB_API_KEY').and_return('envsecret')
      expect(OMDB.api_key).to eq('envsecret')
    end
  end

  describe 'client' do
    it "instantiates a Client with the api key" do
      OMDB.api_key = 'secret'
      expect(OMDB::Client).to receive(:new).with(api_key: 'secret')
      OMDB.client
    end

    it "returns the cached client if available" do
      OMDB.api_key = 'secret'
      OMDB.client
      expect(OMDB::Client).not_to receive(:new)
      OMDB.client
    end
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
          expect(@title).to be_instance_of Hash
        end

        it 'should contain a title' do
          expect(@title.title).to be_instance_of String
        end
      end

      describe 'with the year parameter' do
        it 'should not be the same title' do
          VCR.use_cassette('title/year') do
            title1 = OMDB.title('True Grit')
            title2 = OMDB.title('True Grit', year: '1969')
            expect(title1).not_to eq(title2)
          end
        end
      end

      describe 'with the plot parameter' do
        it 'should have different plots' do
          VCR.use_cassette('title/plot') do
            title1 = OMDB.title('Game of Thrones')
            title2 = OMDB.title('Game of Thrones', plot: 'full')
            expect(title1.plot).not_to eq(title2.plot)
          end
        end
      end

      describe 'with the season and episode parameters' do
        it 'should include season and episode in the response' do
          VCR.use_cassette('title/season_and_episode') do
            title = OMDB.title('True Detective', episode: 1, season: 1)
            expect(title.season).to eq('1')
            expect(title.episode).to eq('1')
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
          expect(@title).to be_instance_of Hash
        end

        it 'should return a hash with a false response' do
          expect(@title.response).to eq('False')
        end

        it 'should return a hash with an error message' do
          expect(@title.error).to be_instance_of String
        end
      end

      describe 'with the tomatoes option' do
        before(:all) do
          VCR.use_cassette('title/tomatoes') do
            @title = OMDB.title('inception', :tomatoes => true)
          end
        end

        it 'should contain tomato rating' do
          expect(@title.tomato_rating).to be_instance_of String
        end

        it 'should contain tomato meter' do
          expect(@title.tomato_meter).to be_instance_of String
        end

        it 'should contain tomato reviews' do
          expect(@title.tomato_reviews).to be_instance_of String
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
          expect(@title).to be_instance_of Hash
        end

        it 'should contain a title' do
          expect(@title.title).to be_instance_of String
        end
      end

      describe "with a movie that doesn't exist" do
        before(:all) do
          VCR.use_cassette('id/nonexistent') do
            @title = OMDB.id('tt1231230123')
          end
        end

        it 'should return a hash' do
          expect(@title).to be_instance_of Hash
        end

        it 'should return a hash with a false response' do
          expect(@title.response).to eq('False')
        end

        it 'should return a hash with an error message' do
          expect(@title.error).to be_instance_of String
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
          expect(@results).to be_instance_of Array
        end

        it 'should return an array with hash contents' do
          expect(@results.first).to be_instance_of Hash
        end
      end

      describe 'with a single search result' do
        before(:all) do
          VCR.use_cassette('search/result') do
            @result = OMDB.search('Star Wars Episode IV A New Hope')
          end
        end

        it 'should return a hash of the title' do
          expect(@result).to be_instance_of Hash
        end

        it 'should have a title' do
          expect(@result.title).to eq('Star Wars: Episode IV - A New Hope')
        end
      end

      describe 'with no search results' do
        before(:all) do
          VCR.use_cassette('search/empty') do
            @results = OMDB.search('lsdfoweirjrpwef323423dsfkip')
          end
        end

        it 'should return a hash' do
          expect(@results).to be_instance_of Hash
        end

        it 'should return a hash with a false response' do
          expect(@results.response).to eq('False')
        end

        it 'should return a hash with an error message' do
          expect(@results.error).to be_instance_of String
        end
      end

      describe 'should be aliased to find' do
        it 'should be the same method' do
          VCR.use_cassette('search/find') do
            expect(OMDB.search('Star Wars')).to eq(OMDB.find('Star Wars'))
          end
        end
      end
    end
  end
end
