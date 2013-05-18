class Session < ActiveRecord::Base
  validates :key, :account_id, presence: true
  validates :key, uniqueness: true

  belongs_to :account

  def self.create_with_unique_key!(account, random=SecureRandom)
    begin
      key = random.hex(42)
    end while Session.find_by_key key
    Session.create! key: key, account: account
  end
end
