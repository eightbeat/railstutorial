require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
 test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
    # 無効な送信
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select 'div#error_explanation'
    # 有効な送信
    content = "This micropost really ties the room together"
    picture = fixture_file_upload('test/fixtures/rails.png','image/png')
    assert_difference 'Micropost.count', 1 do
      # post microposts_path, params: { micropost: { content: content } }
       post microposts_path, params: { micropost: { content: content, picture: picture }}
    end
    assert @user.microposts.first.picture?
    follow_redirect!
    assert_match content, response.body
    # 投稿を削除する
    assert_select 'a', text: 'delete'
    micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(micropost)
    end
    # 違うユーザーのプロフィールにアクセス（削除リンクがないことを確認）
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end
  
  test "micropost sidebar count" do                                      
    log_in_as(@user)                                                     #ログインする    
    get root_path                                                        #root_pathへ、getリクエストを送信する
    assert_match "#{@user.microposts.count} microposts", response.body   #michaelユーザのマイクロポスト数をカウントし、複数形で表示されることを確認
    # まだマイクロポストを投稿していないユーザー
    other_user = users(:malory)                                           
    log_in_as(other_user)                                                #別ユーザ（maloryユーザ）でログイン 
    get root_path
    assert_match "0 microposts", response.body                           #HTMLに"0 micropost"と単数形で表示されることを確認
    other_user.microposts.create!(content: "A micropost")                #maloryユーザでマイクロポストを投稿する
    get root_path
    assert_match "1 micropost", response.body                                  #HTMLに"1 micropost"と単数形で表示されることを確認
  end
end
