project('hidapi-d', 'd', 'c',
			version: '1.0.3',
			license: 'MIT')

# Find HIDAPI
hidapi = 'hidapi'
if host_machine.system() == 'linux'
	hidapi = 'hidapi-libusb'
endif
hidapi_dep = dependency(hidapi)

# Subdirectories
subdir('source')
subdir('tests')

# Generate pkgconfig
pkg_mod = import('pkgconfig')
pkg_mod.generate(name: 'hidapi-d',
			libraries : hidapid_lib,
			version: '1.0.3',
			subdirs: 'hidapid',
			description : 'D bindings for HIDAPI')

# Generate dub.json
has_dub_module = false
if has_dub_module
dub_sources = []
foreach path : hidapid_sources
	dub_sources += join_paths('source', path)
endforeach

dlang = import('dlang')
dlang.generate_dub_file(meson.project_name().to_lower(), meson.source_root(),
						authors: 'Filipe Laíns',
						description: 'D bindings for HIDAPI',
						copyright: 'Copyright © 2018, Filipe Laíns',
						license: 'MIT',
						sourceFiles: dub_sources,
						libs: hidapi
)
endif
