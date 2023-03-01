# frozen_string_literal: true

require 'spec_helper_acceptance'

# rubocop:disable RSpec/RepeatedExampleGroupBody
describe 'nm::connection' do
  context 'connection' do
    include_examples 'the example', 'connection.pp'

    it_behaves_like 'an idempotent resource'

    describe file('/etc/NetworkManager/system-connections/test1.nmconnection') do
      it { is_expected.to be_file }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
      it { is_expected.to be_mode '600' } # serverspec does not like a leading 0

      its(:content) do
        is_expected.to match <<~CONTENT
          # THIS FILE IS CONTROLLED BY PUPPET

          [connection]
          id=test1
          type=dummy
          interface-name=dummy1

          [ipv4]
          address1=10.10.10.10/24
          method=manual

          [ipv6]
          method=ignore
        CONTENT
      end
    end

    describe interface('dummy1') do
      it { is_expected.to have_ipv4_address('10.10.10.10/24') }
    end

    describe file('/etc/NetworkManager/system-connections/test2.nmconnection') do
      it { is_expected.to be_file }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
      it { is_expected.to be_mode '600' } # serverspec does not like a leading 0

      its(:content) do
        is_expected.to match <<~CONTENT
          # THIS FILE IS CONTROLLED BY PUPPET

          [connection]
          id=test2
          type=dummy
          interface-name=dummy2

          [ipv4]
          address1=10.20.20.20/24
          method=manual

          [ipv6]
          method=ignore
        CONTENT
      end
    end

    describe interface('dummy2') do
      it { is_expected.to have_ipv4_address('10.20.20.20/24') }
    end

    describe file('/etc/NetworkManager/system-connections/test3.nmconnection') do
      it { is_expected.to be_file }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
      it { is_expected.to be_mode '600' } # serverspec does not like a leading 0

      its(:content) do
        is_expected.to match <<~CONTENT
          [connection]
          id=test3
          type=dummy
          interface-name=dummy3

          [ipv4]
          address1=10.30.30.30/24
          method=manual

          [ipv6]
          method=ignore
        CONTENT
      end
    end

    describe interface('dummy3') do
      it { is_expected.to have_ipv4_address('10.30.30.30/24') }
    end
  end

  context 'connection absent' do
    include_examples 'the example', 'connection_absent.pp'

    it_behaves_like 'an idempotent resource'

    describe file('/etc/NetworkManager/system-connections/test1.nmconnection') do
      it { is_expected.not_to exist }
    end

    describe interface('dummy1') do
      it { is_expected.not_to exist }
    end

    describe file('/etc/NetworkManager/system-connections/test2.nmconnection') do
      it { is_expected.not_to exist }
    end

    describe interface('dummy2') do
      it { is_expected.not_to exist }
    end

    describe file('/etc/NetworkManager/system-connections/test3.nmconnection') do
      it { is_expected.not_to exist }
    end

    describe interface('dummy3') do
      it { is_expected.not_to exist }
    end
  end
end
# rubocop:enable RSpec/RepeatedExampleGroupBody
