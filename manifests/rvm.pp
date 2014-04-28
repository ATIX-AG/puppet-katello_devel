# Setup and create gemset for RVM
class katello_devel::rvm {

  class { '::rvm': }

  rvm::system_user { $katello_devel::user: ; }

  $build_opts = $::operatingsystem ? {
    'RedHat' => [],
    default  => ['--binary']
  }

  augeas { 'katello_devel-sudo':
    context => '/files/etc/sudoers',
    changes => [
      "set Defaults[type = ':${katello_devel::user}']/type :${katello_devel::user}",
      "set Defaults[type = ':${katello_devel::user}']/requiretty/negate ''",
    ],
    require => Rvm::System_user[$katello_devel::user],
  }

  rvm_system_ruby { 'ruby-1.9.3-p448':
    ensure      => 'present',
    default_use => true,
    build_opts  => $build_opts,
  }

  rvm_gem { 'bundler':
    ensure       => latest,
    name         => 'bundler',
    ruby_version => 'ruby-1.9.3-p448',
    require      => Rvm_system_ruby['ruby-1.9.3-p448'],
  }

}
