# this ruby script converts a CSV of results to array patient x lab_test
# Headers of data file: PT_ID, ORDER_NAME, CSF_ORDER_DT, RESULT_ITEM_DESCRIPTION, RESULT_VALUE, RESULT_VALUE_NUM, UNIT_OF_MEASURE

require "csv.rb"

input_filename = "csf-results.csv"
output_filename = "output.csv"

dimension_1 = proc {|e| "#{e["PT_ID"]}|#{e["CSF_ORDER_DT"]}"} # this is the unique identifier for patients
dimension_2 = proc {|e| "#{e["ORDER_NAME"]}|#{e["RESULT_ITEM_DESCRIPTION"]}"} # this is the unique identifier for type of study
value = proc {|e| e["RESULT_VALUE"]}

# read the CSV file
all_data = CSV.read(input_filename, headers: true)
puts "Loaded CSV file: #{all_data.size} entries"

# filter out rows with missing value
# all_data = all_data.select {|e| value.call(e) != nil}
# puts "Filtered out the entries without a value: #{ all_data.size } entries remain"

# get list of patient_ids and test names
row_names = all_data.collect {|e| dimension_1.call(e)}.uniq
column_names = all_data.collect {|e| dimension_2.call(e)}.uniq

# only keep column names if there are at least 3 occurances
column_names.keep_if {|e| all_data.count {|f| dimension_2.call(f)==e} > 1 }

puts "Will produce an #{row_names.size} x #{column_names.size} table where rows represent indiviual patients and columns represent various study names"

# produce a hash that allows access by all_data_by_name_and_test["PT_ID|TEST_NAME"]
all_data_by_name_and_test = all_data.group_by {|e| "#{dimension_1.call(e)}|#{dimension_2.call(e)}"}

# produce a master array and write to file
CSV.open(output_filename, "w") do |csv|
  csv << ["UNIQUE"] + column_names
  
  master_array = row_names.each do |row_name|
    csv << [row_name] + column_names.collect {|column_name|
      (all_data_by_name_and_test["#{row_name}|#{column_name}"] || []).collect {|e| value.call(e) || "BLANK VALUE"}.compact.first
    }
  end
end
puts "Saved as #{output_filename}"
