Sequel.migration do
  up do
    add_column :peliculas, :fecha_agregado, Date

    from(:peliculas).update(fecha_agregado: Sequel.lit('CURRENT_DATE'))

    alter_table :peliculas do
      set_column_default :fecha_agregado, Sequel.lit('CURRENT_DATE')
    end
  end

  down do
    drop_column :peliculas, :fecha_agregado
  end
end
