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
  # db_setup
  # import_file
  find_parent_names
  number_of_nodes_per_person
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
def find_parent_names
  @father_names = []
  @mother_names = []

  Sample.all.each do |sample|
    parents = sample.target_name.split("-")
    @father_names << parents[0]
    @mother_names << parents[1]
  end
end

# How many times you have same person 
def number_of_nodes_per_person
  target_file = open("number_of_networks_a_person_is_in.txt", 'w')

  count = Hash.new(0)

  @father_names.each do |v|
    count[v] += 1
  end

  target_file << count.each do |k, v|
    puts "#{k} appears #{v} times"
  end
end


# Find unique names & save on txt



# Compare parent's - child's name



# How many children per person
