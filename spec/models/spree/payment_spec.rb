require 'spec_helper'

describe Spree::Payment do
  let(:subject) { create :payment }
  describe '#save_to_brightpearl' do
    it 'adds one job' do
      expect{ subject.complete }.
        to change(Sidekiq::Extensions::DelayedClass.jobs, :size).
        by(1)
    end
  end
end
