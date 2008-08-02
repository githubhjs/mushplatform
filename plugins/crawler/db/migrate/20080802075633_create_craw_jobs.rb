class CreateCrawJobs < ActiveRecord::Migration
  
  def self.up
    create_table :craw_jobs do |t|
      t.integer :site_id,:crawler_pid,:default => 0
    end
  end

  def self.down
    drop_table :craw_jobs
  end
  
end
