Sequel.migration do
  up do
    create_table(:peliculas) do
      primary_key :id
      String :titulo
      Integer :anio
      String :genero
      Date :created_on
      Date :updated_on
    end
  end

  down do
    drop_table(:peliculas)
  end
end
