require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  
  test "create should require logged-in user" do 
    assert_no_difference "Relationship.count" do                       #Relationship.countが変わらないこと
      post relationships_path                                          #postリクエストを送信（relationships_path）
    end
    assert_redirected_to login_url                                     #ログイン画面へリダイレクトされる
  end
  
  test "destroy should require logged-in user" do
    assert_no_difference 'Relationship.count' do                       #Relationship.countが変わらないこと
      delete relationship_path(relationships(:one))                    #deleteリクエストを送信（relationship_path(relationship(:one))）
    end
    assert_redirected_to login_url                                     #ログイン画面へリダイレクトされる
  end
end
