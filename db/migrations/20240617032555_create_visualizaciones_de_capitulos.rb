Sequel.migration do
  up do
    create_table(:visualizaciones_de_capitulos) do
      primary_key :id
      foreign_key :id_usuario, :usuarios, null: false, type: :Integer, on_delete: :cascade
      foreign_key :id_contenido, :contenidos, null: false, type: :Integer, on_delete: :cascade
      Time :fecha
      Integer :numero_capitulo
      Date :created_on
      Date :updated_on
    end
  end

  down do
    drop_table(:visualizaciones_de_capitulos)
  end
end
