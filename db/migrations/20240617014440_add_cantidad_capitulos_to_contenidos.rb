Sequel.migration do
  up do
    add_column :contenidos, :cantidad_capitulos, Integer
  end

  down do
    drop_column :contenidos, :cantidad_capitulos
  end
end
