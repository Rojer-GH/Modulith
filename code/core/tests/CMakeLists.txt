# Tests CMakeLists

file(GLOB_RECURSE SOURCE_LIST CONFIGURE_DEPENDS "src/**.cpp" "src/**.h")

add_executable(ModulithEngineTests ${SOURCE_LIST})

target_include_directories(ModulithEngineTests PRIVATE ${MODULITH_VCPKG_INCLUDE})
target_link_libraries(ModulithEngineTests PRIVATE common ModulithEngine)

MODULITH_COPY_FILE_TO_OUTPUT(ModulithEngineTests $<TARGET_FILE:ModulithEngine> ModulithEngine.dll)