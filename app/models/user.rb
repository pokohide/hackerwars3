class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:twitter]

  validates :username, presence: true, uniqueness: true

  #登録時にemailを不要とする
  def email_required?
    false
  end
  def email_changed?
    false
  end

  def self.find_for_oauth(auth)
    # providerとuidでUserレコードを取得する。存在しない場合は、ブロック内のコードを実行して作成
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create( 
        uid: auth.uid,
        provider: auth.provider,
        username: auth.info.name,
        email: User.get_email(auth),
        password: Devise.friendly_token[4, 30],
        thumbnail: auth.info.image,
        score: 0 
      ) 
      user.save
    end
    user
  end

  #Devise の RegistrationsController はリソースを生成する前にself.new_with_controllerを呼ぶ
  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
        new(session["devise.user_attributes"], without_protection: true) do |user|
            user.attributes = params
            user.valid?
        end
    else
        super
    end
  end

  #providerがある場合はパスワードを要求しないようにする
  def password_required?
    super && provider.blank?
  end

  #プロフィールを変更する時に呼ばれる
  def update_with_password(params, *options)
    update_attributes(params, *options)
  end

  private
    def self.get_email(auth)
      email = auth.info.email
      email = "#{auth.provider}-#{auth.uid}@example.com" if email.blank?
      email
    end
end
