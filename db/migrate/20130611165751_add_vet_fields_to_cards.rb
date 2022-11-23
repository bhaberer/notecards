# frozen_string_literal: true

class AddVetFieldsToCards < ActiveRecord::Migration
  def change
    add_column :cards, :rotation, :string
    add_column :cards, :time_in, :datetime
    add_column :cards, :time_out, :datetime
    add_column :cards, :notes_duration, :integer
  end
end
