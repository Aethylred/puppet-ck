require 'spec_helper'

describe 'ck::repository', :type => :class do

  $supported_os.each do | os_expects |
    os      = os_expects[:os]
    facts   = os_expects[:facts]
    expects = os_expects[:expects]
    context "on #{os}" do
      let (:facts) { facts }
      describe 'with no parameters' do
        case facts[:osfamily]
        when 'Debian'
          if facts[:operatingsystem] == 'Ubuntu' and Gem::Version.new(facts[:lsbdistrelease]) < Gem::Version.new('14.10')
            it { should raise_error(Puppet::Error,
                %r{There is no repository URL for ck for #{facts[:operatingsystem]} #{facts[:lsbdistrelease]}}
            ) }
          else
            it { should contain_class('ck::params') }
          end
        else 
          it { should raise_error(Puppet::Error,
              %r{There is no repository URL for ck for #{facts[:operatingsystem]} #{facts[:lsbdistrelease]}}
          ) }
        end
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