class CreateVocations < ActiveRecord::Migration
  def self.up
    create_table :vocations do |t|
      t.string :vocation_name,:null => false
    end
    %w{保险 银行 证券 基金 通讯 汽车 制造 房地产  医疗与健康 教育 媒体 政府 商业
     旅游 交通与物流 IT  邮政 能源 供应商 外包 外包基地  其它}.each do |v_name|
      Vocation.create(:vocation_name => v_name)
    end
  end

  def self.down
    drop_table :vocations
  end
end
