Sequel.migration do
  up do
    rename_table :peliculas, :contenidos
  end

  down do
    rename_table :contenidos, :peliculas
  end
end
