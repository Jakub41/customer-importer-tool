require 'rails_helper'

RSpec.describe Companies::Importer::Customer do
  let(:data)    { ['Customer Name', 'Address', '11000', 'City', 'Denmark', 'DK', 'user@mail.com'] }
  let(:company) { create(:company) }

  subject { Companies::Importer::Customer.new(data: data, company: company).call }

  context 'when the data is correct' do
    it 'creates the customer' do
      expect { subject }.to change(Customer, :count).by(1)
    end

    it 'creates the user' do
      expect { subject }.to change(User, :count).by(1)
    end

    it 'assigns customer data correctly' do
      expect(subject.object[:customer].name).to eq 'Customer Name'
      expect(subject.object[:customer].address).to eq 'Address'
      expect(subject.object[:customer].zip_code).to eq '11000'
      expect(subject.object[:customer].city).to eq 'City'
      expect(subject.object[:customer].country_code).to eq 'DK'
      expect(subject.object[:customer].company).to eq company
      expect(subject.object[:customer].user_email).to eq 'user@mail.com'
    end
  end

  context 'when the user email is not present' do
    let(:data) { ['Customer Name', 'Address', '11000', 'City', 'Denmark', 'DK', ''] }

    it 'doesn\'t create the customer' do
      expect { subject }.to change(Customer, :count).by(0)
    end

    it 'doesn\'t create the user' do
      expect { subject }.to change(User, :count).by(0)
    end

    it 'returns an error' do
      expect(subject.errors).to eq ['Error creating customer: user email missing.']
    end
  end

  context 'when the data isn\'t correct' do
    let(:data) { ['', 'Address', '11000', 'City', 'Country', 'user@mail.com'] }

    it 'returns an error' do
      expect(subject.errors).to eq ['Error creating customer: customer name missing.']
    end
  end
end
