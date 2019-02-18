require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  
  def setup
    @user = users(:michael)
  end
  
  test "prpfile display" do
    get user_path(@user)                                    #GETリクエスト送信（ユーザープロフィールページ）
    assert_template 'users/show'                            #ユーザープロフィールページ（users/show）のテンプレートが表示されること
    assert_select 'title', full_title(@user.name)           #HTMLのtitle属性にユーザーの名前が表示されること
    assert_select 'h1', text: @user.name                    #HTMLのh1タグにユーザーの名前が表示されること
    #assert_select 'h1>img.gravatar'                        #HTMLのh1タグの下に、imgタグ（gravatorクラス付き）が表示されること
    assert_match @user.microposts.count.to_s, response.body  #ユーザーのマイクロポスト数をカウントして文字列に変換する。レスポンスのHTML内に存在するかチェック
    assert_select 'div.pagination'                          #HTMLにdivタグ（paginationクラス付き）が表示されること
    @user.microposts.paginate(page: 1).each do |micropost|  #ユーザーのマイクロポストから、paginateを使って１ページ目を取得する。取得した結果を繰り返す
      assert_match micropost.content, response.body         #マイクロポストのcontent属性が、レスポンスのHTML内に存在するかチェック
    end
  end
end
