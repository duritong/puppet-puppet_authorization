#
# @summary Define type to manage the puppetserver authorization
#
# @param version [Integer]
#   The version of the authorization
#
# @param allow_header_cert_info [Boolean]
#   Whether to allow header cert info
#
# @param replace [Boolean]
#   Whether to replace the file
#
# @param path [Stdlib::Absolutepath]
#   The path to the file
#
define puppet_authorization (
  Integer $version = 1,
  Boolean $allow_header_cert_info = false,
  Boolean $replace = false,
  Stdlib::Absolutepath $path = $name,
) {
  concat { $name:
    path    => $path,
    replace => $replace,
  }

  concat::fragment { "00_header_${name}":
    target  => $name,
    content => "authorization: {
  rules: []
",
  }

  concat::fragment { "99_footer_${name}":
    target  => $name,
    content => "}
",
  }

  hocon_setting { "authorization.version.${name}":
    path    => $path,
    setting => 'authorization.version',
    value   => $version,
    require => Concat[$name],
  }

  hocon_setting { "authorization.allow-header-cert-info.${name}":
    path    => $path,
    setting => 'authorization.allow-header-cert-info',
    value   => $allow_header_cert_info,
    require => Concat[$name],
  }
}
