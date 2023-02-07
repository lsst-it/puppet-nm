# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'nm class' do
  context 'without any parameters' do
    let(:manifest) do
      <<-PP
      include nm
      PP
    end

    it_behaves_like 'an idempotent resource'
  end
end
