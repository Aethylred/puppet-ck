require 'spec_helper'

describe 'ck::source::tar', :type => :class do

  $supported_os.each do | os_expects |
    os      = os_expects[:os]
    facts   = os_expects[:facts]
    expects = os_expects[:expects]
    context "on #{os}" do
      let (:facts) { facts }
      it { should contain_class('ck::params') }
      describe 'with no parameters' do
        it { should contain_file('ck_src_download_dir').with(
          'ensure' => 'directory',
          'path'   => '/usr/src/ck-0.4.5'
        ) }
        it { should contain_exec('get_ck_source_tarball').with(
          'path'    => ['/usr/bin','/bin'],
          'command' => "wget -O - http://concurrencykit.org/releases/ck-0.4.5.tar.gz|tar xzv -C /usr/src/ck-0.4.5 --strip-components=1",
          'creates' => '/usr/src/ck-0.4.5/README',
          'require' => 'File[ck_src_download_dir]'
        ) }
        it { should contain_file('ck_src_dir').with(
          'ensure' => 'link',
          'path'   => '/usr/src/ck',
          'target' => '/usr/src/ck-0.4.5'
        ) }
      end
      describe 'when specifying another version' do
        let :params do
          {
            :version => '4.0.0',
          }
        end
        it { should contain_file('ck_src_download_dir').with(
          'ensure' => 'directory',
          'path'   => '/usr/src/ck-4.0.0'
        ) }
        it { should contain_exec('get_ck_source_tarball').with(
          'path'    => ['/usr/bin','/bin'],
          'command' => "wget -O - http://concurrencykit.org/releases/ck-4.0.0.tar.gz|tar xzv -C /usr/src/ck-4.0.0 --strip-components=1",
          'creates' => '/usr/src/ck-4.0.0/README',
          'require' => 'File[ck_src_download_dir]'
        ) }
        it { should contain_file('ck_src_dir').with(
          'ensure' => 'link',
          'path'   => '/usr/src/ck',
          'target' => '/usr/src/ck-4.0.0'
        ) }
      end
      describe 'when specifying all parameters' do
        let :params do
          { :src_url => 'https://somewhere.org/this.tar.gz',
            :version => '4.0.0',
            :src_dir => '/src/ck'
          }
        end
        it { should contain_file('ck_src_download_dir').with(
          'ensure' => 'directory',
          'path'   => '/src/ck-4.0.0'
        ) }
        it { should contain_exec('get_ck_source_tarball').with(
          'path'    => ['/usr/bin','/bin'],
          'command' => "wget -O - https://somewhere.org/this.tar.gz|tar xzv -C /src/ck-4.0.0 --strip-components=1",
          'creates' => '/src/ck-4.0.0/README',
          'require' => 'File[ck_src_download_dir]'
        ) }
        it { should contain_file('ck_src_dir').with(
          'ensure' => 'link',
          'path'   => '/src/ck',
          'target' => '/src/ck-4.0.0'
        ) }
      end
    end
  end
  context "on and Unknown operating system" do
    let (:facts) do
      { :osfamily => 'Unknown' }
    end
    it { should raise_error(Puppet::Error,
      %r{The ck Puppet module does not support Unknown family of operating systems}
    ) }
  end
end
