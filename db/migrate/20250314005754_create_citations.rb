class CreateCitations < ActiveRecord::Migration[8.0]
  def change
    create_table :citations do |t|
      t.references :paper, null: false, foreign_key: true
      t.string :cited_paper_arxiv_id

      t.timestamps
    end
  end
end
