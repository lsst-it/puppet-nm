# frozen_string_literal: true

require 'spec_helper'

describe 'nm' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with no parameters' do
        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_file('/etc/sysconfig/network-scripts').with(
            ensure: 'directory',
            purge: true,
            recurse: true,
            force: true
          )
        end

        it do
          is_expected.to contain_file('/etc/NetworkManager/conf.d').with(
            ensure: 'directory',
            purge: true,
            recurse: true,
            force: true
          )
        end

        it do
          is_expected.to contain_file('/etc/NetworkManager/NetworkManager.conf').with(
            ensure: 'file',
            mode: '0644'
          )
        end

        it do
          is_expected.to contain_file('/etc/NetworkManager/system-connections').with(
            ensure: 'directory',
            purge: true,
            recurse: true,
            force: true
          )
        end

        it do
          is_expected.to contain_exec('nmcli conn reload').with(
            command: '/bin/nmcli conn reload',
            refreshonly: true,
            timeout: 30,
            tries: 3,
            try_sleep: 10
          )
        end
      end

      context 'with connections param' do
        let(:params) do
          {
            connections: {
              foo: {
                content: 'bar',
              },
              baz: {
                content: 'quix',
              },
            },
          }
        end

        it { is_expected.to contain_nm__connection('foo').with_content('bar') }
        it { is_expected.to contain_nm__connection('baz').with_content('quix') }
      end
    end
  end
end
