module MoviesHelper
  def watchlist_action(user, movie)
    if user.present? && user.watchlist_includes?(movie)
    return link_to("Remove from Watchlist", remove_from_watchlist_movie_path(movie))
    end 
    link_to "Add to Watchlist", add_to_watchlist_movie_path(movie)
  end
end
