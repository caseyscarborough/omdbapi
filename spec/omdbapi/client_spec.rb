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
        let(:title) { OMDB.title('Star Wars') }

        it 'should return a hash of movie attributes' do
          title.should be_instance_of Hash
        end

        it 'should contain a title' do
          title.title.should be_instance_of String
        end
      end

      describe 'with the year parameter' do
        let(:title1) { OMDB.title('True Grit') }
        let(:title2) { OMDB.title('True Grit', year: '1969') }

        it 'should not be the same title' do
          title1.should_not eq(title2)
        end
      end

      describe 'with the plot parameter' do
        let(:title1) { OMDB.title('Game of Thrones') }
        let(:title2) { OMDB.title('Game of Thrones', plot: 'full') }

        it 'should have different plots' do
          title1.plot.should_not eq(title2.plot)
        end
      end

      describe 'with a movie that doesn''t exist' do
        let(:title) { OMDB.title('lsdfoweirjrpwef323423dsfkip') }
        
        it 'should return a hash' do
          title.should be_instance_of Hash
        end

        it 'should return a hash with a false response' do
          title.response.should eq('False')
        end

        it 'should return a hash with an error message' do
          title.error.should be_instance_of String
        end
      end
    end

    describe 'id' do

      describe 'with a title that exists' do
        let(:title) { OMDB.id('tt0411008') }

        it 'should return a hash of movie attributes' do
          title.should be_instance_of Hash
        end

        it 'should contain a title' do
          title.title.should be_instance_of String
        end
      end

      describe 'with a movie that doesn''t exist' do
        let(:title) { OMDB.id('tt1231230123') }
        
        it 'should return a hash' do
          title.should be_instance_of Hash
        end

        it 'should return a hash with a false response' do
          title.response.should eq('False')
        end

        it 'should return a hash with an error message' do
          title.error.should be_instance_of String
        end
      end
    end

    describe 'search' do

      describe 'with search results' do
        let(:results) { OMDB.search('Star Wars') }

        it 'should return an array' do
          results.should be_instance_of Array
        end

        it 'should return an array with hash contents' do
          results[0].should be_instance_of Hash
        end
      end

      describe 'with a single search result' do
        let(:result) { OMDB.search('Star Wars: Episode VI - Return of the Jedi') }

        it 'should return a hash of the title' do
          result.should be_instance_of Hash
        end

        it 'should have a title' do
          result.title.should eq('Star Wars: Episode VI - Return of the Jedi')
        end
      end

      describe 'with no search results' do
        let(:results) { OMDB.search('lsdfoweirjrpwef323423dsfkip') }

        it 'should return a hash' do
          results.should be_instance_of Hash
        end

        it 'should return a hash with a false response' do
          results.response.should eq('False')
        end

        it 'should return a hash with an error message' do
          results.error.should be_instance_of String
        end
      end

      describe 'should be aliased to find' do
        it 'should be the same method' do
          OMDB.search('Star Wars').should eq(OMDB.find('Star Wars'))
        end
      end
    end

  end

end