require 'csv'
class CsvDb
  class << self
    def convert_save(target_model, csv_data, &block)
      target_model.transaction do
        csv_file = csv_data.read
        CSV.parse(csv_file, :headers => true, header_converters: :symbol ) do |row|
          data = row.to_hash
          if data.present?
            if (block_given?)
               value = block.call(target_model, data)
               if value[:error].present?
                 raise value[:error]
               end
             else
               target_model.create!(data)
            end
          end
        end
      end
    end
  end
end
