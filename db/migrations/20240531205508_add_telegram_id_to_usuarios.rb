Sequel.migration do
  up do
    add_column :usuarios, :id_telegram, :Bignum
  end

  down do
    drop_column :usuarios, :id_telegram
  end
end
