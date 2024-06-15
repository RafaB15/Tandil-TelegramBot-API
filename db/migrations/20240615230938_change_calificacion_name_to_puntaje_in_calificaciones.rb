Sequel.migration do
  up do
    rename_column :calificaciones, :calificacion, :puntaje
  end

  down do
    rename_column :calificaciones, :puntaje, :calificacion
  end
end
