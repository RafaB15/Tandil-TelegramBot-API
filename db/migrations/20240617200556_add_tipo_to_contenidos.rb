Sequel.migration do
  up do
    add_column :contenidos, :tipo, String
  end

  down do
    drop_column :contenidos, :tipo
  end
end
