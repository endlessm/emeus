project('emeus', 'c',
        version: '0.99.1',
        default_options: [
          'buildtype=debug',
          'c_std=c99',
          'warning_level=1'
        ],
        license: 'LGPLv2.1+',
        meson_version: '>= 0.44.0')

emeus_version = meson.project_version().split('.')
emeus_major_version = emeus_version[0].to_int()
emeus_minor_version = emeus_version[1].to_int()
emeus_micro_version = emeus_version[2].to_int()

emeus_is_development = emeus_minor_version.is_odd()

if emeus_minor_version > 90
  emeus_api_version = '@0@.0'.format(emeus_major_version + 1)
else
  emeus_api_version = '@0@.0'.format(emeus_major_version)
endif

if emeus_is_development
  emeus_interface_age = 0
else
  emeus_interface_age = emeus_micro_version
endif

emeus_binary_age = emeus_minor_version * 100 + emeus_micro_version

# Shared library versioning
current = emeus_binary_age - emeus_interface_age
revision = emeus_interface_age
libversion = '0.@0@.@1@'.format(current, revision)

# Paths for the pkg-config file
emeus_prefix = get_option('prefix')
emeus_bindir = join_paths(emeus_prefix, get_option('bindir'))
emeus_libdir = join_paths(emeus_prefix, get_option('libdir'))
emeus_datadir = join_paths(emeus_prefix, get_option('datadir'))
emeus_includedir = join_paths(emeus_prefix, get_option('includedir'))

cc = meson.get_compiler('c')
host_system = host_machine.system()

conf = configuration_data()
conf.set_quoted('PACKAGE_NAME', meson.project_name())
conf.set_quoted('PACKAGE_VERSION', meson.project_version())
conf.set_quoted('PACKAGE_STRING', '@0@-@1@'.format(meson.project_name(), meson.project_version()))
conf.set_quoted('PACKAGE_DATADIR', join_paths(get_option('prefix'), get_option('datadir')))
conf.set_quoted('PACKAGE_LIBDIR', join_paths(get_option('prefix'), get_option('datadir')))
conf.set_quoted('PACKAGE_LOCALE_DIR', join_paths(get_option('prefix'), get_option('datadir'), 'locale'))
conf.set_quoted('PACKAGE_LIBEXECDIR', join_paths(get_option('prefix'), get_option('libexecdir')))
conf.set('GETTEXT_PACKAGE', 'PACKAGE_NAME')
conf.set('LOCALEDIR', 'PACKAGE_LOCALE_DIR')
conf.set10('ENABLE_NLS', true) # Always enabled

# Compiler flags
test_cflags = [
  '-fstrict-aliasing',
  '-Wpointer-arith',
  '-Wmissing-declarations',
  '-Wformat=2',
  '-Wstrict-prototypes',
  '-Wmissing-prototypes',
  '-Wnested-externs',
  '-Wold-style-definition',
  '-Wunused',
  '-Wuninitialized',
  '-Wshadow',
  '-Wmissing-noreturn',
  '-Wmissing-format-attribute',
  '-Wredundant-decls',
  '-Wlogical-op',
  '-Wcast-align',
  '-Wno-unused-local-typedefs',
  '-Werror=implicit',
  '-Werror=init-self',
  '-Werror=main',
  '-Werror=missing-braces',
  '-Werror=return-type',
  '-Werror=array-bounds',
  '-Werror=write-strings'
]
common_cflags = cc.get_supported_arguments(test_cflags)

# Check for headers
test_headers = [
  'stdlib.h',
  'stdint.h',
  'stdbool.h',
]
foreach h: test_headers
  conf.set('HAVE_' + h.underscorify().to_upper(), cc.has_header(h))
endforeach

# Debugging
debug_cflags = []
buildtype = get_option('buildtype')

if buildtype.startswith('debug')
  debug_cflags += [
    '-DEMEUS_ENABLE_DEBUG'
  ]
elif buildtype == 'release'
  debug_cflags += [
    '-DG_DISABLE_CAST_CHECKS'
  ]
endif


# Detect and set symbol visibility
if get_option('default_library') != 'static'
  if host_system == 'windows'
    conf.set('DLL_EXPORT', true)
    conf.set('_EMEUS_PUBLIC', '__declspec(dllexport) extern')
    if cc.get_id() != 'msvc'
      add_global_arguments('-fvisibility=hidden', language: 'c')
    endif
  else
    conf.set('_EMEUS_PUBLIC', '__attribute__((visibility("default"))) extern')
    add_global_arguments('-fvisibility=hidden', language: 'c')
  endif
endif

# Required dependencies
mathlib_dep = cc.find_library('m', required: false)

glib_dep = dependency('glib-2.0', version: '>= 2.46')

gtk_version_req_major = 3
gtk_version_req_minor = 20
gtk_version_req_micro = 0
gtk_version_required = '@0@.@1@.@2@'.format(gtk_version_req_major, gtk_version_req_minor, gtk_version_req_micro)
gtk_version_is_development = gtk_version_req_minor.is_odd()
gtk_version_cflags = []
if gtk_version_is_development
  # Ensure we're using the newly added API at most
  min_required = 'GDK_VERSION_@0@_@1@'.format(gtk_version_req_major, gtk_version_req_minor - 1)
  max_allowed = 'GDK_VERSION_@0@_@1@'.format(gtk_version_req_major, gtk_version_req_minor + 1)
  gtk_version_cflags += [
    '-DGDK_VERSION_MIN_REQUIRED=' + min_required,
    '-DGDK_VERSION_MAX_ALLOWED=' + max_allowed,
  ]
endif

gtk_dep = dependency('gtk+-3.0', version: '>= ' + gtk_version_required)

gnome = import('gnome')
i18n = import('i18n')

podir = join_paths(meson.current_source_dir(), 'po')

subdir('src')
subdir('examples')
subdir('po')

if get_option('gtk_doc')
  subdir('doc')
endif

meson.add_install_script('build-aux/post-install.sh')
