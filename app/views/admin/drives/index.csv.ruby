require 'csv'

direct_column_names = %w[start_meter end_meter start_at end_at]
indirect_column_names = {
  car: :name,
  user: :name
}

CSV.generate(encoding: Encoding::SJIS, row_sep: "\r\n", force_quotes: true) do |csv|
  csv << (direct_column_names + indirect_column_names.keys)
  @drives.each do |drive|
    direct_values = drive.attributes.values_at(*direct_column_names)
    indirect_values = indirect_column_names.map { |k, v| drive.send(k).send(v) }
    csv << (direct_values + indirect_values)
  end
end
