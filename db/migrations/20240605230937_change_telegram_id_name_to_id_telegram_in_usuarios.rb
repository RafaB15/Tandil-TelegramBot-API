Sequel.migration do
  up do
    rename_column :usuarios, :telegram_id, :id_telegram
  end

  down do
    rename_column :usuarios, :id_telegram, :id_telegram
  end
end
