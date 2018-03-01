gen_constraints = executable(
  'emeus-gen-constraints', 'emeus-gen-constraints.c',
  include_directories: emeus_inc,
  dependencies: [ glib_dep, mathlib_dep ],
  link_with: libemeus_private,
  install: true,
)

# Desktop launcher and description file.
i18n.merge_file(
  'desktop',
  input: 'com.endlessm.EmeusEditor.desktop.in',
  output: 'com.endlessm.EmeusEditor.desktop',
  install: true,
  install_dir: join_paths(emeus_datadir, 'applications'),
  po_dir: podir,
  type: 'desktop',
)

# Service file
serviceconf = configuration_data()
serviceconf.set('bindir', emeus_bindir)

configure_file(
  input: 'com.endlessm.EmeusEditor.service.in',
  output: 'com.endlessm.EmeusEditor.service',
  configuration: serviceconf,
  install: true,
  install_dir: join_paths(emeus_datadir, 'dbus-1/services'))

editor_sources = [
  'emeus-edit-constraints.c'
]

editor_resources = gnome.compile_resources(
  'editor-resources',
  'editor.gresource.xml',
  c_name: '_editor',
)

editor = executable(
  'emeus-edit-constraints',
  editor_sources + editor_resources,
  include_directories: emeus_inc,
  c_args: [ '-DG_LOG_STRUCTURED=1', '-DG_LOG_DOMAIN="Editor"' ],
  dependencies: [ emeus_dep ],
  link_with: libemeus_private,
  install: true,
)

install_data(
  'com.endlessm.EmeusEditor.png',
  install_dir: join_paths(emeus_datadir, 'icons/hicolor/256x256/apps'),
)
