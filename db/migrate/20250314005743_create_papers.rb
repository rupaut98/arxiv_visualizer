class CreatePapers < ActiveRecord::Migration[8.0]
  def change
    create_table :papers do |t|
      t.string :arxiv_id
      t.string :title
      t.text :authors
      t.text :abstract
      t.string :url
      t.date :published_date

      t.timestamps
    end
  end
end
