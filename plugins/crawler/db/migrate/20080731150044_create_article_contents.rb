class CreateArticleContents < ActiveRecord::Migration
  def self.up
    create_table :article_contents do |t|
      t.integer :catelog_index,:default => 0
      t.integer :catelog_name
      t.text    :content
      t.datetime :created_at
      t.integer :article_id,:null => false,:default => 0
    end
  end

  def self.down
    drop_table :article_contents
  end
end
