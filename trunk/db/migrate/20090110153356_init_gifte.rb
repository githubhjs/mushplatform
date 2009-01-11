class InitGifte < ActiveRecord::Migration
  
  def self.up
    Dir.glob("#{RAILS_ROOT}/public/images/gifts_imgs/*.gif").each do |gift_image|
      Gift.create(:icon => File.basename(gift_image))
    end
  end

  def self.down
    Gift.delete_all
  end

end
