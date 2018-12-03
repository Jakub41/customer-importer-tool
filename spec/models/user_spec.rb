# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'password complexity validation' do
    let(:user) { build(:user) }

    def assert_invalid(password)
      user.password = password
      user.valid?
      expect(user.errors[:password]).to be_present
    end

    def assert_valid(password)
      user.password = password
      user.valid?
      expect(user.errors[:password]).to be_blank
    end

    it 'allows only passwords with min 8 chars, a special char, a number, an uppercase letter' do
      assert_invalid '12345678Aa'
      assert_valid '12345678Aa$'
    end
  end
end
