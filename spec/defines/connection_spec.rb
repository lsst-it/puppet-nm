# frozen_string_literal: true

require 'spec_helper'

shared_examples 'ensure param' do
  context 'with ensure =>' do
    context 'with absent' do
      let(:params) { { content: 'bar', ensure: 'absent' } }

      it do
        is_expected.to contain_file('/etc/NetworkManager/system-connections/foo.nmconnection').with(
          ensure: 'absent'
        )
      end
    end

    context 'with present' do
      let(:params) { { content: 'bar', ensure: 'present' } }

      it do
        is_expected.to contain_file('/etc/NetworkManager/system-connections/foo.nmconnection').with(
          ensure: 'file'
        )
      end
    end
  end
end

describe 'nm::connection' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:title) { 'foo' }
      let(:pre_condition) do
        <<~PP
          include nm
        PP
      end

      context 'when content is String' do
        let(:params) { { content: 'bar' } }

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_file('/etc/NetworkManager/system-connections/foo.nmconnection').with(
            ensure: 'file',
            mode: '0600',
            content: 'bar'
          ).that_notifies('Exec[nmcli conn reload]')
        end

        it_behaves_like 'ensure param'
      end

      context 'when content is Hash' do
        let(:params) do
          {
            content: {
              'bar' => {
                'baz'   => 'quix',
                'quack' => 42,
              }
            }
          }
        end

        it do
          is_expected.to contain_file('/etc/NetworkManager/system-connections/foo.nmconnection').with(
            ensure: 'file',
            mode: '0600',
            content: <<~CONTENT
              # THIS FILE IS CONTROLLED BY PUPPET

              [bar]
              baz=quix
              quack=42
            CONTENT
          ).that_notifies('Exec[nmcli conn reload]')
        end

        it_behaves_like 'ensure param'
      end
    end
  end
end
