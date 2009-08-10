ActiveRecord::Schema.define(:version => 0) do
  create_table :users, :force => true do |t|
    t.integer :money
  end
  create_table :people, :force => true do |t|
    t.integer :money
  end
end