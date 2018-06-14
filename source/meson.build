inc = include_directories('.')

# Library

hidapid_sources = [
    'hidapi/bindings.d',
    'hidapi/device.d',
    'hidapi/error.d'
]

hidapid_lib = static_library('hidapid',
                                hidapid_sources,
                                include_directories: inc,
                                dependencies: hidapi_dep,
                                install : true)