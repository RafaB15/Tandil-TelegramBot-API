Sequel.migration do
  up do
    create_table(:favoritos) do
      primary_key :id
      foreign_key :id_usuario, :usuarios, null: false, type: :Integer, on_delete: :cascade
      foreign_key :id_pelicula, :peliculas, null: false, type: :Integer, on_delete: :cascade
      Date :created_on
      Date :updated_on
    end
  end

  down do
    drop_table(:favorito)
  end
end
