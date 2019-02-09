class kapacitor::install {
  $kapacitor::gem_dependencies.each |String $gem_name, Hash $gem| {
    package {$gem_name:
      * => $gem,
      provider => "puppet_gem"
    }
  }

  case $kapacitor::service_provider {
    "docker": {
      docker_image {$kapacitor::service_image: }
    }
    default: {
      # $kapacitor::packages.each |String $package_name, Hash $package| {
      #   package {$package_name:
      #     * => $package
      #   }
      # }

      $package_source_name = $::architecture ? {
        /386/   => "kapacitor_${::kapacitor::version}_i386.deb",
        default => "kapacitor_${::kapacitor::version}_amd64.deb",
      }

      $package_source = "https://dl.influxdata.com/kapacitor/releases/${kapacitor::version}"
      include wget
      wget::fetch { 'kapacitor':
        source      => $package_source,
        destination => "/tmp/${package_source_name}"
      }
      package { 'kapacitor':
        ensure   => present,
        provider => 'dpkg',
        source   => "/tmp/${package_source_name}",
        require  => Wget::Fetch['kapacitor'],
      }
    }
  }
}
