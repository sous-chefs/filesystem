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
  its('device') { should eq '/dev/loop0' }
  its('type') { should eq 'ext3' }
end
