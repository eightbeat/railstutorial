require 'test_helper'

class MicropstsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @micropost = microposts(:orange)
  end
  
  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do                                  #Micropostモデルの数をカウントし、数が変化していないこと
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }  #POSTリクエストを送信する
    end
    assert_redirected_to login_url                                             #ログイン画面にリダイレクトされること
  end
  
  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:michael))                   #michaelユーザでログインする
    micropost = microposts(:ants)                #マイクロポストのfixtureのantsを取得する（archerユーザのマイクロポスト）
    assert_no_difference 'Micropost.count' do   #マイクロポストの件数が変わらないことを確認
      delete micropost_path(micropost)          #マイクロポストを削除する
    end
    assert_redirected_to root_url
  end
    
end
