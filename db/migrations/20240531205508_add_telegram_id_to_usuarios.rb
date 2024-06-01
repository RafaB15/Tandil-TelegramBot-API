Sequel.migration do
  up do
    add_column :usuarios, :telegram_id, :Bignum
  end

  down do
    drop_column :usuarios, :telegram_id
  end
end
