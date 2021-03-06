require 'spec_helper'

describe 'ck::source::install', :type => :class do
  $supported_os.each do | os_expects |
    os      = os_expects[:os]
    facts   = os_expects[:facts]
    expects = os_expects[:expects]
    context "on #{os}" do
      let (:facts) { facts }
      describe "with no parameters" do
        it { should contain_class('ck::params') }
        it { should contain_exec('install_ck_src').with(
          'command' => 'make install',
          'cwd'     => '/usr/src/ck',
          'creates' => '/usr/local/lib/libck.so',
          'path'    => ['/usr/bin','/bin'],
          'require' => 'Exec[configure_ck_src]'
        ) }
      end
      describe "with custom parameters" do
        let :params do
          { :src_dir     => '/src/concurrencykit' }
        end
        it { should contain_class('ck::params') }
        it { should contain_exec('install_ck_src').with(
          'command' => 'make install',
          'cwd'     => '/src/concurrencykit',
          'creates' => '/usr/local/lib/libck.so',
          'path'    => ['/usr/bin','/bin'],
          'require' => 'Exec[configure_ck_src]'
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
