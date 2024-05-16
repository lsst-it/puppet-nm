# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'nm class' do
  context 'without any parameters' do
    include_examples 'the example', 'nm.pp'

    it_behaves_like 'an idempotent resource'

    describe package('NetworkManager') do
      it { is_expected.to be_installed }
    end

    describe file('/etc/sysconfig/network-scripts/readme-ifcfg-rh.txt') do
      case fact('os.release.major')
      when '7', '8'
        it { is_expected.not_to be file }
      else
        it { is_expected.to be_file }
      end
    end

    describe file('/etc/NetworkManager/NetworkManager.conf') do
      it { is_expected.to be_file }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
      it { is_expected.to be_mode '644' } # serverspec does not like a leading 0

      its(:content) do
        is_expected.to match <<~CONTENT
          # THIS FILE IS CONTROLLED BY PUPPET

          [main]

          [logging]
        CONTENT
      end
    end

    describe service('NetworkManager') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end

  context 'with conf parameter' do
    include_examples 'the example', 'nm_conf.pp'

    describe file('/etc/NetworkManager/NetworkManager.conf') do
      it { is_expected.to be_file }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
      it { is_expected.to be_mode '644' } # serverspec does not like a leading 0
      it { is_expected.that_notifies 'Service[NetworkManager]' }

      its(:content) do
        is_expected.to match <<~CONTENT
          # THIS FILE IS CONTROLLED BY PUPPET

          [main]
          dns=none
          no-auto-default=*
        CONTENT
      end
    end
  end
end
