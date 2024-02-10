# Modules CMakeLists

# TODO
# Execute a python script, that reads a better version of the modules' metadata file, and (re)generates CMake files accordingly.

add_subdirectory(renderer)
add_subdirectory(game)
add_subdirectory(editor)
add_subdirectory(physics)
add_subdirectory(shooter)
add_subdirectory(mario)
add_subdirectory(core)
# add_subdirectory(core-tests) Building fails...