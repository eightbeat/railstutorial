require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:michael)
    # このコードは慣習的に正しくない
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end
  
  test "should be valid" do
    assert @micropost.valid?
  end
  
  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
  
  #content属性が存在すること
  test "content should be present" do
    @micropost.content = " "
    assert_not @micropost.valid?
  end
  
  #最大140文字であることの検証を追加する。
  test "content should be at most 140 characters" do
    @micropost.content = "a"*141
    assert_not @micropost.valid?
  end
  
  #マイクロポストの順序付けをテストする
   test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
