module Companies
  module Importer
    class Document
      ACCEPTED_FORMATS = ['.xls', '.xlsx', '.csv'].freeze

      def initialize(file:, company:)
        @file         = file
        @company_name = company
        @results      = []
      end

      def call
        if company_name.blank?
          ServiceResult.new(errors: 'Company not present.')
        elsif file.blank?
          ServiceResult.new(errors: 'File not present.')
        elsif invalid_format?
          ServiceResult.new(errors: 'Invalid file format.')
        else
          import_document
        end
      end

      private

      attr_reader :file, :company_name, :results

      def company
        @company ||= Company.find_or_create_by(name: company_name)
      end

      def file_ext
        @file_ext ||= File.extname(file.path)
      end

      def invalid_format?
        !ACCEPTED_FORMATS.include?(file_ext)
      end

      def document
        @document ||= open_file.parse
      end

      def open_file
        case file_ext
        when '.xls' then
          Roo::Excel.new(file.path)
        when '.xlsx' then
          Roo::Excelx.new(file.path)
        when '.csv' then
          Roo::CSV.new(file.path, csv_options: { col_sep: ';' })
        end
      end

      def import_document
        error = nil

        ActiveRecord::Base.transaction do
          document.each_with_index do |data, index|
            result = Customer.new(data: data, company: company).call

            if result.success?
              results[index] = result.messages
            else
              results[index] = result.errors
            end
          end
        end

        ServiceResult.new(
          object: { results: results, company: company },
          messages: ["Importation finished successfully."]
        )
      end
    end
  end
end
