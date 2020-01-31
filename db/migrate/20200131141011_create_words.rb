class CreateWords < ActiveRecord::Migration[5.2]
  def change
    create_table :words do |t|
      t.string :name
      t.string :definition
      t.string :citations
      t.date :day

      t.timestamps
    end
  end
end
