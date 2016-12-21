class AlbumsController < ApplicationController
  load_and_authorize_resource only: [:new, :create, :show]
  before_action :set_attributes, only: :create
  before_action :album_support, only: [:show]

  def show
    @commentable = @album
    @comment = Comment.new
  end

  def new
  end

  def create
    if @album.save
      flash[:success] = t "flash.create_success"
      redirect_to @album.user
    else
      album_support
      flash[:danger] = @album.errors.full_messages.join("/ ")
      redirect_to :back
    end
  end

  private
  def album_params
    params.require(:album).permit :name, :album_type, :user_id
  end

  def set_attributes
    @album.album_type = "favorite"
    @album.user = current_user
  end

  def album_support
    @support = Supports::AlbumSupport.new @album
  end
end
