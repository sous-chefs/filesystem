# frozen_string_literal: true

require 'spec_helper'

describe 'filesystem_create_all_from_key' do
  step_into :filesystem_create_all_from_key
  platform 'ubuntu', '24.04'

  context 'with explicit filesystem properties' do
    recipe do
      filesystem_create_all_from_key 'filesystems' do
        filesystems(
          'deferred' => {
            'device' => '/dev/missing',
            'device_defer' => true,
            'fstype' => 'ext4',
            'mount' => '/mnt/deferred',
          }
        )
      end
    end

    it { is_expected.to create_filesystem('deferred').with(device_defer: true) }
  end
end
