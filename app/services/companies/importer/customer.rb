module Companies
  module Importer
    class Customer
      def initialize(data:, company:)
        @data    = data
        @company = company
      end

      def call
        if customer_name.blank?
          ServiceResult.new(errors: "Error creating customer: customer name missing.")
        elsif user_email.blank?
          ServiceResult.new(errors: "Error creating customer: user email missing.")
        else
          ServiceResult.new(
            object: { customer: customer, user: user },
            messages:[ "#{customer.name} created successfully"]
          )
        end
      rescue StandardError => e
        ServiceResult.new(errors: "Error creating customer: #{e.message}")
      end

      private

      attr_reader :data, :company, :index

      def customer_name
        @customer_name ||= data[0]
      end

      def customer_address
        @customer_address ||= data[1]
      end

      def customer_zip
        @customer_zip ||= fix_xls_string(data[2].to_s)
      end

      def customer_city
        @customer_city ||= data[3]
      end

      def user_email
        @user_email ||= data[6]
      end

      def fix_xls_string(str)
        str =~ /\.0$/ ? str : str.gsub(/\.0$/, '')
      end

      def country_code
        data[5].try(:upcase).try(:strip) || ISO3166::Country.find_country_by_name(data[4]).try(:alpha2)
      end

      def customer
        return if customer_name.blank?

        @customer ||= create_customer
      end

      def create_customer
        customer = ::Customer.find_or_initialize_by(
          company: company,
          name: customer_name
        )

        customer.assign_attributes(
          user: user,
          address: customer_address,
          zip_code: customer_zip,
          city: customer_city,
          country_code: country_code
        )

        customer.save!

        customer
      end

      def user
        return if user_email.blank?

        @user ||= User.find_or_create_by!(email: user_email) do |user|
          user.password = Devise.friendly_token[0, 20] + '1A$'
        end
      end
    end
  end
end
