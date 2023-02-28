# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'nm::connection' do
  context 'connection' do
    include_examples 'the example', 'connection.pp'

    it_behaves_like 'an idempotent resource'

    describe file('/etc/NetworkManager/system-connections/test.nmconnection') do
      it { is_expected.to be_file }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
      it { is_expected.to be_mode '600' } # serverspec does not like a leading 0

      its(:content) do
        is_expected.to match <<~CONTENT
          # THIS FILE IS CONTROLLED BY PUPPET

          [connection]
          id=test
          type=ethernet
          interface-name=test

          [ipv4]
          address1=10.10.10.10/24
          method=manual

          [ipv6]
          method=disable
        CONTENT
      end
    end
  end
end
