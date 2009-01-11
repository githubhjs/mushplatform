class InitRegards < ActiveRecord::Migration
  def self.up
    Dir.glob("#{RAILS_ROOT}/public/images/regard_imgs/*.gif").each do |gift_image|
      Regard.create(:icon => File.basename(gift_image))
    end
  end

  def self.down
    Regard.delete_all
  end
end
