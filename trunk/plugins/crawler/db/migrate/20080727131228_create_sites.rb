class CreateSites < ActiveRecord::Migration
  
  def self.up
    create_table :sites do |t|
      t.string   :site_name
      t.string   :site_url,:limit => 255
      t.integer  :status,:state,:default => 0
      t.integer  :time_out,:default => 120
      t.datetime :last_finish_time,:default => Time.now
      t.integer  :craw_freq,:default => 24*60*60#hour
      t.integer  :request_freq,:default => 1
      t.integer  :craw_now,:defult => 0
    end
     id | site_name | site_url                 | status | state | time_out | last_finish_time    | craw_freq | request_freq |
+----+-----------+--------------------------+--------+-------+----------+---------------------+-----------+--------------+
|  6 | readnovel | http://www.readnovel.com |      0 |     0 |      120 | 2008-08-01 15:18:01 |     86400 |            1 
    Site.create(:site_name => 'readnovel',)
  end

  def self.down
    
  end
  
end
