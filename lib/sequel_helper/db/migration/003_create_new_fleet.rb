Sequel.migration do
  up do
    create_table(:new_fleet) do
      primary_key :id
      String :name
      String :name2
      String :description
    end
  end

  down do
    drop_table(:new_fleet)
  end
end