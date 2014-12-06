class ejabberd::certificate (
  $servercertfile,
  $templatestorage,
  $ejabberd_group,
) {

  $templatefile = split($servercertfile, '/')[-1]
  case $templatestorage {
    'puppet': {
                file { "${servercertfile}":
		  owner   => 'root',
                  group   => $ejabberd_group,
                  mode    => '0640',
                  source => 'puppet://ejabberd/ejabberd.pem'
		}
              }
    'hiera': {
                file { "${servercertfile}":
		  owner   => 'root',
                  group   => $ejabberd_group,
                  mode    => '0640',
                  content => hiera($templatefile),
                }
             }
    default: { fail("templatestorage must be either 'puppet' or 'hiera'") }
  }
}
