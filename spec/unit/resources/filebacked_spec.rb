# frozen_string_literal: true

require 'spec_helper'

describe 'filesystem_filebacked' do
  step_into :filesystem_filebacked
  platform 'ubuntu', '24.04'

  context 'when the backing file does not exist' do
    before do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with('/opt/loop.img').and_return(false)

      allow_any_instance_of(Chef::Provider).to receive(:shell_out).and_return(
        instance_double(Mixlib::ShellOut, stdout: '')
      )
      allow_any_instance_of(Chef::Provider).to receive(:shell_out!).and_return(true)
    end

    recipe do
      filesystem_filebacked '/opt/loop.img' do
        device '/dev/loop5'
        size '100'
      end
    end

    it { is_expected.to create_directory('/opt') }
  end
end
