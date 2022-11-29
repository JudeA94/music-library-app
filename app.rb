# file: app.rb
require 'sinatra'
require 'sinatra/reloader'
require_relative 'lib/album'
require_relative 'lib/artist'
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/albums' do
    repo = AlbumRepository.new
    @albums = repo.all
    return erb(:all_albums)
  end

  get '/albums/new' do
    return erb(:new_album_form)
  end

  get '/albums/:id' do
    album_repo = AlbumRepository.new
    album = album_repo.find(params[:id])
    @title = album.title
    @release_year = album.release_year
    artist_repo = ArtistRepository.new
    artist = artist_repo.find(album.artist_id)
    @artist_name = artist.name
    return erb(:album)
  end

  get '/artists' do
    repo = ArtistRepository.new
    @artists = repo.all
    return erb(:all_artists)
  end

  get '/artists/new' do
    return erb(:new_artist_form)
  end

  get '/artists/:id' do
    repo = ArtistRepository.new
    artist = repo.find(params[:id])
    @name = artist.name
    @genre = artist.genre
    return erb(:artist)
  end

  post '/albums' do
    if !params[:title].empty? and params[:release_year].to_i.digits.length == 4 and params[:artist_id].match?(/^[0-9]*$/)
      @title = params[:title]
      @release_year = params[:release_year]
      @artist_id = params[:artist_id]
      album = Album.new
      album.title = @title
      album.release_year = @release_year
      album.artist_id = @artist_id
      repo = AlbumRepository.new
      repo.create(album)
      return erb(:post_album_form)
    else
      status 400
      return erb(:invalid_album_input)
    end
  end

  post '/artists' do
    if !params[:name].empty? and !params[:genre].empty?
      @name = params[:name]
      @genre = params[:genre]

      artist = Artist.new
      artist.name = @name
      artist.genre = @genre

      repo = ArtistRepository.new
      repo.create(artist)
      return erb(:post_artist_form)
    else
      status 400
      return erb(:invalid_artist_input)
    end
  end
end
