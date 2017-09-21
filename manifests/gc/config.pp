class docker::gc::config {
  File {
    owner => "root",
    group => "root"
  }

  $exclude_images_file = "${docker::gc::config_dir}/exclude-images.conf"
  $exclude_containers_file = "${docker::gc::config_dir}/exclude-containers.conf"

  file {
    $docker::gc::config_dir:
      mode => '0755',
      ensure => "directory";

    $docker::gc::config_file:
      mode => '0644',
      content => epp('docker/docker-gc.conf.epp', {
        'opts' => merge($docker::gc::opts, {
          'exclude_from_gc' => $exclude_images_file,
          'exclude_containers_from_gc' => $exclude_containers_file
        })
      });

    $exclude_images_file:
      mode => '0644',
      content => epp('docker/gc-exclude.conf.epp', {
        'exclude' => $docker::gc::exclude_images
      });

    $exclude_containers_file:
      mode => '0644',
      content => epp('docker/gc-exclude.conf.epp', {
        'exclude' => $docker::gc::exclude_containers
      })
  }

  cron {'docker-gc':
    *       => $docker::gc::cron,
    command => "docker run --rm --env-file=${docker::gc::config_file} -v ${docker::gc::state_dir}:${docker::gc::state_dir}:rw -v ${docker::gc::config_dir}:${docker::gc::config_dir}:ro -v ${docker::unix_socket}:${docker::unix_socket} ${docker::gc::image_name} >${docker::gc::log_file}",
    user    => 'root',
    ensure  => $docker::gc::enable ? {
      true  => 'present',
      false => 'absent'
    },
    require => Docker_image[$docker::gc::image_name]
  }
}
