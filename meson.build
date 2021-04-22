project('com.github.abbysoft-team.compose', 'vala', 'c', version: '0.0.1')

gnome = import('gnome')
i18n = import('i18n')

add_project_arguments([
    '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
    '-g'],
    language: 'c'
)

asresources = gnome.compile_resources(
    'as-resources',
    join_paths('data', meson.project_name()) + '.gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

add_project_arguments([
    '--vapidir', join_paths(meson.current_source_dir(), 'vapi'),
    '--pkg', 'posix'],
    language: 'vala'
)

# Add the math library
cc = meson.get_compiler('c')
math_dep = cc.find_library('m', required: true)

dependencies = [
    dependency('granite', version: '>=5.2.4'), # 5.2.4 is the first release to support the Launcher API
    dependency('gtk+-3.0'),
    dependency('alsa'),
    dependency('libpulse'),
    dependency('libpulse-mainloop-glib'),
    math_dep

]

subdir('src')

executable(
    meson.project_name(),
    asresources,
    sources,
    dependencies: dependencies,
    install: true
)

subdir('data')
subdir('po')

meson.add_install_script('meson/post_install.py')
