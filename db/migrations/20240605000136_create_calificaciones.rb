Sequel.migration do
  up do
    create_table(:calificaciones) do
      primary_key :id
      foreign_key :id_usuario, :usuarios, null: false, type: :Integer, on_delete: :cascade
      foreign_key :id_pelicula, :peliculas, null: false, type: :Integer, on_delete: :cascade
      Integer :calificacion
      Date :created_on
      Date :updated_on
    end
  end

  down do
    drop_table(:calificacion)
  end
end
