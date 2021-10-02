project('libsoup-test', 'vala', 'c',
  version: '0.0.1')

dependencies = [
  dependency('glib-2.0'),
  dependency('gio-2.0'),
  dependency('gobject-2.0'),
  dependency('libsoup-2.4')
]

add_project_arguments(['--enable-experimental'], language: 'vala')

subdir('src')
