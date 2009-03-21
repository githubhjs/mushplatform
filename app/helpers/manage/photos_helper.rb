module  Manage::PhotosHelper

  def generate_album_options(selected_value)
    options = current_user.albums.map{|album|[album.title,"#{album.id.to_s}"]}
    options_for_select(options,selected_value)
  end

end
