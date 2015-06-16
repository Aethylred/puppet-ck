require 'spec_helper'

describe 'ck::source::git', :type => :class do
  $supported_os.each do | os_expects |
    os      = os_expects[:os]
    facts   = os_expects[:facts]
    expects = os_expects[:expects]
    context "on #{os}" do
      let (:facts) { facts }
      describe "with no parameters" do
        it { should contain_class('ck::params') }
        it { should contain_vcsrepo("#{expects[:src_dir]}-git-#{expects[:version]}").with(
          'ensure'   => 'present',
          'provider' => 'git',
          'source'   => expects[:git_url],
          'revision' => expects[:version]
        ) }
        it { should contain_file('ck_git_src_dir').with(
          'ensure'  => 'directory',
          'path'    => "#{expects[:src_dir]}-git-#{expects[:version]}",
          'require' => "Vcsrepo[#{expects[:src_dir]}-git-#{expects[:version]}]"
        ) }
        it { should contain_file('ck_src_dir').with(
          'ensure' => 'link',
          'path'   => expects[:src_dir],
          'target' => "#{expects[:src_dir]}-git-#{expects[:version]}"
        ) }
      end
      describe "with custom parameters" do
        let :params do
          { :git_url => 'git@somewhere.org/ck.git',
            :version => 'seven',
            :src_dir => '/src/concurrencykit'
          }
        end
        it { should contain_class('ck::params') }
        it { should contain_vcsrepo( '/src/concurrencykit-git-seven').with(
          'ensure'   => 'present',
          'provider' => 'git',
          'source'   => 'git@somewhere.org/ck.git',
          'revision' => 'seven'
        ) }
        it { should contain_file('ck_git_src_dir').with(
          'ensure'  => 'directory',
          'path'    => '/src/concurrencykit-git-seven',
          'require' => "Vcsrepo[/src/concurrencykit-git-seven]"
        ) }
        it { should contain_file('ck_src_dir').with(
          'ensure' => 'link',
          'path'   => '/src/concurrencykit',
          'target' => '/src/concurrencykit-git-seven'
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
