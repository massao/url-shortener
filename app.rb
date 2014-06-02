require 'active_record'

ActiveRecord::Base.logger = Logger.new(File.open('db.log', 'w'))
ActiveRecord::Base.establish_connection(
	:adapter => 'sqlite3',
	:database => 'example.db'
)

ActiveRecord::Schema.define do
	unless ActiveRecord::Base.connection.tables.include? 'urls'
		create_table :urls do |table|
			table.column :key, :string
			table.column :url, :string
		end
	end
end
