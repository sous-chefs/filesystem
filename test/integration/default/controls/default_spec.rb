# frozen_string_literal: true

control 'filesystem-filebacked-01' do
  impact 1.0
  title 'File-backed filesystem is created and mounted'

  describe file('/opt/loop.img') do
    it { should be_file }
    it { should exist }
    its('size') { should > 1 }
  end

  describe directory('/mnt/loop-1') do
    it { should exist }
    it { should be_directory }
  end

  describe mount('/mnt/loop-1') do
    it { should be_mounted }
    its('type') { should eq 'ext3' }
  end

  describe file('/mnt/loop-1/testfile') do
    it { should exist }
    it { should be_file }
  end
end

control 'filesystem-nfs-01' do
  impact 0.5
  title 'Network filesystem fstab entries are enabled on Debian family'
  only_if('NFS recipe only runs on Debian family') { os.family == 'debian' }

  describe etc_fstab.where { mount_point == '/mnt/nfs-1' } do
    its('file_system_type') { should cmp 'nfs' }
  end

  describe etc_fstab.where { mount_point == '/mnt/nfs-4' } do
    its('file_system_type') { should cmp 'nfs4' }
  end
end
