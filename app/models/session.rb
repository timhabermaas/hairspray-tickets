class Session < ActiveRecord::Base
  validates :key, presence: true
  validates :key, uniqueness: true

  def self.create_with_unique_key!(random=SecureRandom)
    begin
      key = random.hex(42)
    end while Session.find_by_key key
    Session.create! key: key
  end
end
