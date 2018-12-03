require 'rails_helper'

RSpec.describe Companies::Importer::Document do
  let(:file) { File.open('spec/fixtures/customers_valid.csv') }

  subject { Companies::Importer::Document.new(file: file, company: 'Company').call }

  let(:customer_result) { ServiceResult.new(messages: ['XXX created successfully']) }

  before do
    allow_any_instance_of(Companies::Importer::Customer).to receive(:call).and_return(customer_result)
  end

  context 'when file format si correct' do
    it 'creates the company' do
      expect { subject }.to change(Company, :count).by(1)
    end

    it 'assigns company data correctly' do
      expect(subject.object[:company].name).to eq 'Company'
    end

    it 'returns the customers created count' do
      expect(subject.messages).to eq ["4 imported successfully"]
    end

    it 'returns a message for each company' do
      expect(subject.object[:results][0]).to eq ['XXX created successfully']
      expect(subject.object[:results][1]).to eq ['XXX created successfully']
      expect(subject.object[:results][2]).to eq ['XXX created successfully']
      expect(subject.object[:results][3]).to eq ['XXX created successfully']
    end
  end

  context 'when the company is not present' do
    subject { Companies::Importer::Document.new(file: file, company: '' ).call }

    it 'returns an error' do
      expect(subject.errors).to eq ['Company not present.']
    end
  end

  context 'when the file is not present' do
    subject { Companies::Importer::Document.new(file: '', company: 'Company' ).call }

    it 'returns an error' do
      expect(subject.errors).to eq ['File not present.']
    end
  end

  context 'when file format si error' do
    let(:file) { File.open('spec/fixtures/customers.txt') }

    it 'returns an error' do
      expect(subject.errors).to eq ['Invalid file format.']
    end
  end
end
