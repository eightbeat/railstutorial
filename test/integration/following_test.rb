require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)                                  #fixtureからmichaelを取得
    @other = users(:archer)
    log_in_as(@user)                                         #fixtureからmichaelを取得
  end
  
  test "following page" do                                      #following page
    get following_user_path(@user)                           #getリクエストを送信（following_user_path(@user))
    assert_not @user.following.empty?                        #フォローユーザが空ではないことを確認
    assert_match @user.following.count.to_s, response.body   #フォローユーザの数がHTML内に存在すること
    @user.following.each do |user|                           #フォローユーザの数だけ繰り返す
      assert_select "a[href=?]", user_path(user)             #フォローユーザのプロフィールページへのリンクが存在すること
    end
  end
  
  test "followers page" do
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end
  
  test "should follow a user the standard way" do                              
    assert_difference '@user.following.count', 1 do                             #@user.following.countが1増えないこと
      post relationships_path, params: { followed_id: @other.id }               #postリクエストを送信（relationship_path)
    end
  end

  test "should follow a user with Ajax" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, xhr: true, params: { followed_id: @other.id }
    end
  end

  test "should unfollow a user the standard way" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test "should unfollow a user with Ajax" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship), xhr: true
    end
  end
end
