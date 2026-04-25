# frozen_string_literal: true

require 'spec_helper'

describe 'filesystem' do
  step_into :filesystem
  platform 'ubuntu', '24.04'

  context 'when enabling a deferred missing device' do
    recipe do
      filesystem 'deferred' do
        device '/dev/missing'
        device_defer true
        fstype 'ext4'
        mount '/mnt/deferred'
        action :enable
      end
    end

    it { is_expected.to create_directory('Mount point for /mnt/deferred').with(path: '/mnt/deferred') }
    it { is_expected.to_not enable_mount('/mnt/deferred') }
  end

  context 'when creating an ext4 filesystem with defaults' do
    before do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with('/dev/test').and_return(true)
      allow(File).to receive(:readlines).and_call_original
      allow(File).to receive(:readlines).with('/proc/mounts').and_return([])

      allow_any_instance_of(Chef::Provider).to receive(:shell_out).with(%r{mount /dev/test}).and_return(
        instance_double(Mixlib::ShellOut, exitstatus: 1)
      )
      allow_any_instance_of(Chef::Provider).to receive(:shell_out).with('which mkfs.ext4').and_return(
        instance_double(Mixlib::ShellOut, exitstatus: 0)
      )
      allow_any_instance_of(Chef::Provider).to receive(:shell_out!).and_return(true)
    end

    recipe do
      filesystem 'defaultfs' do
        device '/dev/test'
        fstype 'ext4'
        action :create
      end
    end

    it { is_expected.to install_package('e2fsprogs') }
  end
end
