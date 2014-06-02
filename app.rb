require	'sinatra'
require 'active_record'

ActiveRecord::Base.logger = Logger.new(File.open('db.log', 'w'))
ActiveRecord::Base.establish_connection(
	:adapter => 'sqlite3',
	:database => 'urls.db'
	)

ActiveRecord::Schema.define do
	unless ActiveRecord::Base.connection.tables.include? 'urls'
		create_table :urls do |table|
			table.column :key, :string
			table.column :url, :string
			table.column :count, :integer
		end
	end
end

class Url < ActiveRecord::Base
	validates :key, uniqueness: true
end

get '/' do
	erb :index, :layout => :layout
end

get '/links' do
	@urls = Url.all;
	erb :links, :layout => :layout
end

post '/new' do
	ok = false
	@url = Url.new
	@url.url = params[:url]
	@url.count = 0
	range = [*'0'..'9', *'a'..'z', *'A'..'Z']
	@url.key = (0...8).map { |n| range.sample }.join
	while ok == false do
		if @url.valid?
			ok = true;
		else
			@url.key = (0...8).map { |n| range.sample }.join
		end
	end
	@url.save
	erb :new, :layout => :layout
end


get '/:id' do
	key = params[:id];
	url = Url.where(key: key).take
	url.count = url.count+1
	url.save
	redirect to(url.url);
end
