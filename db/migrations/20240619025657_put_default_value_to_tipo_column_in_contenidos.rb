Sequel.migration do
  up do
    alter_table(:contenidos) do
      set_column_default :tipo, 'pelicula'
    end

    self[:contenidos].where(tipo: nil).update(tipo: 'pelicula')
  end

  down do
    alter_table(:contenidos) do
      set_column_default :tipo, nil
    end
  end
end
