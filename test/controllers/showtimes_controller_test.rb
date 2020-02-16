require 'test_helper'

class ShowtimesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @showtime = showtimes(:one)
  end

  test "should get index" do
    get showtimes_url
    assert_response :success
  end

  test "should get new" do
    get new_showtime_url
    assert_response :success
  end

  test "should create showtime" do
    assert_difference('Showtime.count') do
      post showtimes_url, params: { showtime: { movie_id: @showtime.movie_id } }
    end

    assert_redirected_to showtime_url(Showtime.last)
  end

  test "should show showtime" do
    get showtime_url(@showtime)
    assert_response :success
  end

  test "should get edit" do
    get edit_showtime_url(@showtime)
    assert_response :success
  end

  test "should update showtime" do
    patch showtime_url(@showtime), params: { showtime: { movie_id: @showtime.movie_id } }
    assert_redirected_to showtime_url(@showtime)
  end

  test "should destroy showtime" do
    assert_difference('Showtime.count', -1) do
      delete showtime_url(@showtime)
    end

    assert_redirected_to showtimes_url
  end
end
