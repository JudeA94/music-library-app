require 'spec_helper'
require 'rack/test'
require_relative '../../app'

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context 'GET /albums' do
    it 'should return the list of albums' do
      response = get('/albums')
      expect(response.status).to eq(200)
      expect(response.body).to include '<h1>Albums</h1>'
      expect(response.body).to include 'Title: Surfer Rosa'
      expect(response.body).to include 'Released: 1988'
      expect(response.body).to include '<a href="/albums/2">Go to this albums page</a>'
      expect(response.body).to include 'Title: Lover'
      expect(response.body).to include 'Released: 2019'
      expect(response.body).to include '<a href="/albums/6">Go to this albums page</a>'
      expect(response.body).to include 'Title: Ring Ring'
      expect(response.body).to include 'Released: 1973'
      expect(response.body).to include '<a href="/albums/12">Go to this albums page</a>'
    end
  end

  context 'GET /albums/:id' do
    it 'returns the HTML content for a single album' do
      response = get('/albums/2')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Surfer Rosa</h1>')
      expect(response.body).to include('Release year: 1988')
      expect(response.body).to include('Artist: Pixies')
    end
    it 'returns the HTML content for a different single album' do
      response = get('/albums/3')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Waterloo</h1>')
      expect(response.body).to include('Release year: 1974')
      expect(response.body).to include('Artist: ABBA')
    end
  end

  context 'GET /artists' do
    it 'returns 200 OK' do
      response = get('/artists')
      expect(response.status).to eq(200)
    end

    it 'returns an HTML page with the list of artists' do
      response = get('/artists')
      expect(response.body).to include '<h1>Artists</h1>'
      expect(response.body).to include 'Name: Pixies'
      expect(response.body).to include 'Genre: Rock'
      expect(response.body).to include '<a href="/artists/1">Go to this artists page</a>'
      expect(response.body).to include 'Name: Nina Simone'
      expect(response.body).to include 'Genre: Pop'
      expect(response.body).to include '<a href="/artists/4">Go to this artists page</a>'
    end
  end

  context 'GET /artists/:id' do
    it 'returns 200 OK' do
      response = get('/artists/1')
      expect(response.status).to eq(200)
    end

    it 'returns the HTML content for a single artist' do
      response = get('/artists/1')
      expect(response.body).to include '<h1>Pixies</h1>'
      expect(response.body).to include '<p>Genre: Rock</p>'
    end

    it 'returns the HTML content for a different single artist' do
      response = get('/artists/2')
      expect(response.body).to include '<h1>ABBA</h1>'
      expect(response.body).to include '<p>Genre: Pop</p>'
    end
  end

  context 'POST /albums' do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = post('/albums?id=13&title=Reputation&release_year=2017&artist_id=3')
      expect(response.status).to eq(200)
      expect(response.body).to include '<h1>New album created</h1>'
      expect(response.body).to include '<p>Title: Reputation</p>'
      expect(response.body).to include '<p>Release year: 2017</p>'
      expect(response.body).to include '<p>Artist id: 3</p>'
      expect(response.body).to include '<a href="/albums">View all albums</a>'
    end

    it 'outputs newly created album' do
      response = get('/albums')
      expect(response.status).to eq(200)
      expect(response.body).to include 'Title: Reputation'
      expect(response.body).to include 'Released: 2017'
    end

    it 'sends to an error page if given dodgy title input' do

    end

    it 'sends to an error page if given dodgy release_year input' do
      
    end
    it 'sends to an error page if given dodgy artist_id input' do
      
    end

  end

  context 'GET /albums/new' do
    it 'returns 200 OK' do
      response = get('/albums/new')
      expect(response.status).to eq(200)
    end

    it 'returns a html page where you can create an album' do
      response = get('/albums/new')
      expect(response.body).to include '<h1>New Album Input Form</h1>'
      expect(response.body).to include '<form action="/albums" method="POST">'
      expect(response.body).to include '<label for="album_title">Album Title:</label><br>'
      expect(response.body).to include '<input type="text" id="album_title" name="title"><br>'
      expect(response.body).to include '<label for="album_release_year">Album Release Year:</label><br>'
      expect(response.body).to include '<input type="text" id="album_release_year" name="release_year"><br>'
      expect(response.body).to include '<label for="album-artist_idr">Artist id:</label><br>'
      expect(response.body).to include '<input type="text" id="album_artist_id" name="artist_id"><br><br>'
      expect(response.body).to include '<input type="submit" value="Submit">'
    end
  end

  context 'GET /artists/new' do
    it 'returns 200 OK' do
      response = get('/albums/new')
      expect(response.status).to eq(200)
    end

    it 'returns a html page where you can create an artist' do
      response = get('/artists/new')
      expect(response.body).to include '<h1>New Artist Input Form</h1>'
      expect(response.body).to include '<form action="/artists" method="POST">'
      expect(response.body).to include '<label for="artist_name">Artist Name:</label><br>'
      expect(response.body).to include '<input type="text" id="artist_name" name="name"><br>'
      expect(response.body).to include '<label for="artist_genre">Artist Genre:</label><br>'
      expect(response.body).to include '<input type="text" id="artist_genre" name="genre"><br>'
      expect(response.body).to include '<input type="submit" value="Submit">'
    end
  end

  context 'POST /artists' do
    it 'returns 200 OK' do
      response = post('/artists?id=6&name=Wild Nothing&genre=indie')
      expect(response.status).to eq(200)
    end

    it 'outputs newly created artist' do
      response = get('/artists')
      expect(response.body).to include 'Name: Wild Nothing'
      expect(response.body).to include 'Genre: indie'
      expect(response.body).to include '<a href="/artists/6">Go to this artists page</a>'
    end

    it 'sends to an error page if given dodgy name input' do

    end

    it 'sends to an error page if given dodgy genre input' do
      
    end
  end
end
