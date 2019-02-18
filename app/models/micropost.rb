class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader                      #引数に、属性名（今回はpicture）と、クラス名（PictureUploader）を指定する。
  validates :user_id, presence: true                            #user_idに対して、「存在性 (Presence)」のバリデーションを追加する
  validates :content, presence: true, length: { maximum: 140 }  #content属性に対して、「存在性 (Presence)」のバリデーションを追加する。
  validate :picture_size                                        #独自のバリデーションを定義するためには、validatesメソッドではなく、validateメソッドを使用する。
  
  private
  
  # アップロードされた画像サイズをバリデーションする
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end
end
