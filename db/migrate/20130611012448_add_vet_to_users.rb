# frozen_string_literal: true

class AddVetToUsers < ActiveRecord::Migration
  def change
    add_column :users, :vet, :boolean, default: false
  end
end
