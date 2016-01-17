# load 'family_dictionary.rb'

require 'active_record'
require 'sqlite3'
require 'pry'
require 'csv'
# require 'smarter_csv'

# Script dictionary
# number of networks a person is in
# - same name of parent part and child
# - multiple nodes with the same name

def commands
	db_setup
	import_file
end


# private

# Create db and object
def db_setup
	ActiveRecord::Base.logger = Logger.new(File.open('database.log', 'w'))

	ActiveRecord::Base.establish_connection(
	  :adapter  => 'sqlite3',
	  :database => 'family_dictionary'
	)

	ActiveRecord::Schema.define do
	  unless ActiveRecord::Base.connection.tables.include? 'samples'
	    create_table :samples do |table|
				table.column :network_no, :string
				table.column :source, :string
				table.column :target, :string
				table.column :source_name, :string
				table.column :target_name, :string
				table.column :source_date, :string
				table.column :target_date, :string
				table.column :source_id, :string
				table.column :target_id, :string
				table.column :source_doc_place, :string
				table.column :target_doc_place, :string
				table.column :source_doc_id, :string
				table.column :target_doc_id, :string
				table.column :source_doc_type, :string
				table.column :target_doc_type, :string
				table.column :source_role, :string
				table.column :target_role, :string
				table.column :target_name_alternative, :string
				table.column :source_name_alternative, :string
	    end
	  end
	end
end

class Sample < ActiveRecord::Base; end


# Import files to database
def import_file
	file_name = "data/family_networks_1.csv"
	CSV.foreach(file_name, { :headers => true, :col_sep => ";" }) do |row|
		row.delete(nil)
    Sample.create!(row.to_hash)
  end
end


# Store names on variables



# How many times you have same person 



# Find unique names & save on txt



# Compare parent's - child's name



# How many children per person
