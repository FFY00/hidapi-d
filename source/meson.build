inc = include_directories('.')

# Library

hidapid_sources = [
    'hidapi/bindings.d',
    'hidapi/device.d',
    'hidapi/devicelist.d',
    'hidapi/error.d',
    'hidapi/hid.d'
]

hidapid_lib = static_library('hidapid',
                                hidapid_sources,
                                include_directories: inc,
                                dependencies: hidapi_dep,
                                install : true)

# Install files from sources array
# Loop needed as meson doesn't preserve the path for some reason
# See: https://github.com/mesonbuild/meson/issues/3371
include_subdir = 'hidapid'
foreach file : hidapid_sources
    file_path = file.split('/')

    # Extract folder
    folder_path = []
    foreach path : file_path
        if path != file_path[-1]
            folder_path += path
        endif
    endforeach

    folder = join_paths(folder_path)
    install_headers(file, subdir: join_paths(include_subdir, folder))
endforeach
