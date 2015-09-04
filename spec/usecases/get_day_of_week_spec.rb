require 'rails_helper'
require_relative '../../app/domain/usecases/weeks/get_day_of_week'

describe 'UseCases::GetDayOfWeek' do

  describe '.get_day_by_id' do

    it 'should return a first day of week' do
      result = Villeme::UseCases::GetDayOfWeek.get_day_by_id(1)

      expect(result).to eq('Sunday')
    end

    it 'should return a last day of week' do
      result = Villeme::UseCases::GetDayOfWeek.get_day_by_id(7)

      expect(result).to eq('Saturday')
    end
  end

end