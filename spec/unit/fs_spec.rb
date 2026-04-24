# frozen_string_literal: true

require 'spec_helper'
require_relative '../../libraries/fs'

describe FilesystemMod do
  subject(:helper) do
    Class.new do
      include FilesystemMod
    end.new
  end

  describe '#netfs?' do
    it 'detects network filesystems' do
      expect(helper.netfs?('nfs')).to be true
      expect(helper.netfs?('ext4')).to be false
    end
  end

  describe 'DEFAULT_FILESYSTEM_TOOLS' do
    it 'defines default packages and force options' do
      expect(described_class::DEFAULT_FILESYSTEM_TOOLS['ext4']).to include(
        'package' => 'e2fsprogs',
        'forceopt' => '-F'
      )
    end
  end
end
