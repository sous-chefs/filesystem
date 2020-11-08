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
  its('device') { should eq '/dev/loop5' }
  its('type') { should eq 'ext3' }
end

describe file('/mnt/loop-1/testfile') do
  it { should exist }
  it { should be_file }
end

if os.family == 'debian'
  describe etc_fstab.where { mount_point == '/mnt/nfs-1' } do
    its('file_system_type') { should cmp 'nfs' }
  end
  describe etc_fstab.where { mount_point == '/mnt/nfs-4' } do
    its('file_system_type') { should cmp 'nfs4' }
  end
end
