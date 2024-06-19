Sequel.migration do
  up do
    rename_column :favoritos, :id_pelicula, :id_contenido
  end

  down do
    rename_column :favoritos, :id_contenido, :id_pelicula
  end
end
