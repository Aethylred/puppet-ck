require 'spec_helper'

describe 'ck::source::build', :type => :class do
  $supported_os.each do | os_expects |
    os      = os_expects[:os]
    facts   = os_expects[:facts]
    expects = os_expects[:expects]
    context "on #{os}" do
      let (:facts) { facts }
      describe "with no parameters" do
        it { should contain_class('ck::params') }
        it { should contain_exec('configure_ck_src').with(
          'command' => '/usr/src/ck/configure',
          'cwd'     => '/usr/src/ck',
          'creates' => '/usr/src/ck/Makefile',
          'path'    => ['/usr/bin','/bin']
        ) }
        it { should_not contain_exec('make_regressions_ck_src') }
        it { should contain_exec('make_ck_src').with(
          'command' => 'make',
          'cwd'     => '/usr/src/ck',
          'path'    => ['/usr/bin','/bin'],
          'require' => 'Exec[configure_ck_src]'
        ) }
      end
      describe "when doing regressions" do
        let :params do
          { :regressions => true }
        end
        it { should contain_class('ck::params') }
        it { should contain_exec('configure_ck_src').with(
          'command' => '/usr/src/ck/configure',
          'cwd'     => '/usr/src/ck',
          'creates' => '/usr/src/ck/Makefile',
          'path'    => ['/usr/bin','/bin']
        ) }
        it { should contain_exec('make_regressions_ck_src').with(
          'command' => 'make regressions',
          'cwd'     => '/usr/src/ck',
          'path'    => ['/usr/bin','/bin'],
          'before'  => 'Exec[make_ck_src]',
          'require' => 'Exec[configure_ck_src]'
        ) }
        it { should contain_exec('make_ck_src').with(
          'command' => 'make',
          'cwd'     => '/usr/src/ck',
          'path'    => ['/usr/bin','/bin'],
          'require' => 'Exec[configure_ck_src]'
        ) }
      end
      describe "with custom parameters" do
        let :params do
          { :regressions => true,
            :src_dir     => '/src/concurrencykit'
          }
        end
        it { should contain_class('ck::params') }
        it { should contain_exec('configure_ck_src').with(
          'command' => '/src/concurrencykit/configure',
          'cwd'     => '/src/concurrencykit',
          'creates' => '/src/concurrencykit/Makefile',
          'path'    => ['/usr/bin','/bin']
        ) }
        it { should contain_exec('make_regressions_ck_src').with(
          'command' => 'make regressions',
          'cwd'     => '/src/concurrencykit',
          'path'    => ['/usr/bin','/bin'],
          'before'  => 'Exec[make_ck_src]',
          'require' => 'Exec[configure_ck_src]'
        ) }
        it { should contain_exec('make_ck_src').with(
          'command' => 'make',
          'cwd'     => '/src/concurrencykit',
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
