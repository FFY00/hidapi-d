# Test executables
exe = executable('test-hidapi-rival310', 'example.d',
					include_directories : inc,
					link_with: hidapid_lib,
					dependencies: hidapi_dep)
test('hidapi-rival310', exe)