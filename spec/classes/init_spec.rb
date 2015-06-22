require 'spec_helper'

describe 'ck', :type => :class do
  $supported_os.each do | os_expects |
    os      = os_expects[:os]
    facts   = os_expects[:facts]
    expects = os_expects[:expects]
    context "on #{os}" do
      let (:facts) { facts }
      if facts[:osfamily] == 'Debian'
        let (:pre_conditions) {'include apt'}
      end
      describe "with no parameters" do
        it { should contain_class('ck::params') }
        it { should_not contain_class('ck::repository') }
        it { should_not contain_class('ck::source::build') }
        it { should_not contain_class('ck::source::install') }
        it { should_not contain_class('ck::source::git') }
        it { should_not contain_class('ck::source::tar') }
        if expects[:packages]
          Array(expects[:packages]).each do |pkg|
            it { should contain_package(pkg).with_ensure('present')}
          end
        end
        if expects[:dev_packages]
          Array(expects[:dev_packages]).each do |pkg|
            it { should_not contain_package(pkg) }
          end
        end
      end
      describe "when managing package repositories" do
        let (:params) do
          { :manage_repos => true }
        end
        case facts[:osfamily]
        when 'Debian'
          if facts[:operatingsystem] == 'Ubuntu' and Gem::Version.new(facts[:lsbdistrelease]) >= Gem::Version.new('14.10')
            it { should contain_class('ck::repository') }
            it { should_not contain_class('ck::source::build') }
            it { should_not contain_class('ck::source::install') }
            it { should_not contain_class('ck::source::git') }
            it { should_not contain_class('ck::source::tar') }
            if expects[:packages]
              Array(expects[:packages]).each do |pkg|
                it { should contain_package(pkg).with_ensure('present')}
              end
            end
            if expects[:dev_packages]
              Array(expects[:dev_packages]).each do |pkg|
                it { should_not contain_package(pkg) }
              end
            end
          else
            it { should raise_error(Puppet::Error,
                %r{There is no repository URL for ck for #{facts[:operatingsystem]} #{facts[:lsbdistrelease]}}
            ) }
          end
        else 
          it { should raise_error(Puppet::Error,
              %r{There is no repository URL for ck for #{facts[:operatingsystem]} #{facts[:lsbdistrelease]}}
          ) }
        end
      end
      describe "when providing a repository URL" do
        let (:params) do
          {
            :manage_repos => true,
            :repo_url     => 'ppa:someones/ppa'
          }
        end
        case facts[:osfamily]
        when 'Debian'
          if facts[:operatingsystem] == 'Ubuntu'
            it { should contain_class('ck::repository').with_repo_url('ppa:someones/ppa') }
            if expects[:packages]
              Array(expects[:packages]).each do |pkg|
                it { should contain_package(pkg).with_ensure('present')}
              end
            end
            if expects[:dev_packages]
              Array(expects[:dev_packages]).each do |pkg|
                it { should_not contain_package(pkg) }
              end
            end
          else
            it { should raise_error(Puppet::Error,
                %r{The ck module can not configure a repository for #{facts[:operatingsystem]}}
            ) }
          end
        else 
          it { should raise_error(Puppet::Error,
              %r{The ck module can not configure a repository for #{facts[:operatingsystem]}}
          ) }
        end
      end
      describe "when trying to build without source" do
        let (:params) do
          {
            :provider => 'package',
            :build    => true
          }
        end
        it { should_not contain_class('ck::source::build') }
        it { should_not contain_class('ck::source::install') }
        it { should_not contain_class('ck::source::git') }
        it { should_not contain_class('ck::source::tar') }
      end
      describe "when trying to build with git" do
        let (:params) do
          {
            :provider => 'git',
            :build    => true
          }
        end
        it { should contain_class('ck::source::build').with(
          'src_dir'     => '/usr/src/ck',
          'regressions' => false
        ) }
        it { should contain_class('ck::source::install').with(
          'src_dir'     => '/usr/src/ck'
        ) }
        it { should contain_class('ck::source::git').with(
          'git_url' => expects[:git_url],
          'version' => '0.4.5',
          'src_dir' => '/usr/src/ck',
          'before'  => 'Anchor[before_build]'
        ) }
        it { should_not contain_class('ck::source::tar') }
      end
      describe "when customising build with git" do
        let (:params) do
          {
            :provider => 'git',
            :build    => true,
            :git_url => 'git@git.org/ck.git',
            :version => '3.0.0',
            :src_dir => '/src/ck',
          }
        end
        it { should contain_class('ck::source::build').with(
          'src_dir'     => '/src/ck',
          'regressions' => false
        ) }
        it { should contain_class('ck::source::install').with(
          'src_dir'     => '/src/ck'
        ) }
        it { should contain_class('ck::source::git').with(
          'git_url' => 'git@git.org/ck.git',
          'version' => '3.0.0',
          'src_dir' => '/src/ck',
          'before'  => 'Anchor[before_build]'
        ) }
        it { should_not contain_class('ck::source::tar') }
      end
      describe "when trying to build with source" do
        let (:params) do
          {
            :provider => 'tar',
            :build    => true
          }
        end
        it { should contain_class('ck::source::build').with(
          'src_dir'     => '/usr/src/ck',
          'regressions' => false
        ) }
        it { should contain_class('ck::source::install').with(
          'src_dir'     => '/usr/src/ck'
        ) }
        it { should_not contain_class('ck::source::git') }
        it { should contain_class('ck::source::tar').with(
          'src_url' => nil,
          'src_dir' => '/usr/src/ck',
          'version' => '0.4.5',
          'before'  => 'Anchor[before_build]'
        ) }
      end
      describe "when customising build with source" do
        let (:params) do
          {
            :provider => 'tar',
            :build    => true,
            :src_url  => 'https://somewhere.org/ck.tar.gz',
            :version  => '3.0.0',
            :src_dir  => '/src/ck'
          }
        end
        it { should contain_class('ck::source::build').with(
          'src_dir'     => '/src/ck',
          'regressions' => false
        ) }
        it { should contain_class('ck::source::install').with(
          'src_dir'     => '/src/ck'
        ) }
        it { should_not contain_class('ck::source::git') }
        it { should contain_class('ck::source::tar').with(
          'src_url' => 'https://somewhere.org/ck.tar.gz',
          'src_dir' => '/src/ck',
          'version' => '3.0.0',
          'before'  => 'Anchor[before_build]'
        ) }
      end
      describe "when building regressions" do
        let (:params) do
          {
            :provider    => 'tar',
            :build       => true,
            :regressions => true
          }
        end
        it { should contain_class('ck::source::build').with(
          'regressions' => true
        ) }
        it { should_not contain_class('ck::source::git') }
        it { should contain_class('ck::source::tar') }
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
