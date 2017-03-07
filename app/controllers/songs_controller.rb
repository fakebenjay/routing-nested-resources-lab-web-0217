class SongsController < ApplicationController
  # rescue_from ActiveRecord::RecordNotFound, :with => :artist_not_found

  def index
    if Artist.find_by(id: params[:artist_id])
      @songs = Artist.find(params[:artist_id]).songs
    elsif !Artist.find_by(id: params[:artist_id]) && params[:artist_id]
      artist_not_found
    else
      @songs = Song.all
    end
  end

  def show
    if params[:artist_id]
      @artist = Artist.find(params[:artist_id])
    end

    if Song.find_by(id: params[:id])
      @song = Song.find(params[:id])
    else
      song_not_found
    end
  end

  def new
    @song = Song.new
  end

  def create
    @song = Song.new(song_params)

    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  def edit
    @song = Song.find(params[:id])
  end

  def update
    @song = Song.find(params[:id])

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist_name)
  end

  def artist_not_found
    redirect_to artists_path
    flash[:alert] = "Artist not found."
  end

  def song_not_found
    if params[:artist_id]
      redirect_to artist_songs_path(@artist)
    else
      redirect_to songs_path
    end
      flash[:alert] = "Song not found."
  end
end
