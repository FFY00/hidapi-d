project('hidapi-d', 'd', 'c',
			version: 'ALPHA-0',
			license: 'AGPLv3')

# Find HIDAPI
hidapi = 'hidapi'
if host_machine.system() == 'linux'
	hidapi = 'hidapi-libusb'
endif
hidapi_dep = dependency(hidapi)

# Subdirectories
subdir('source')
subdir('tests')

# Generate dub.json
has_dub_module = true
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
							license: 'AGPLv3',
							sourceFiles: dub_sources,
							libs: hidapi
	)
endif
