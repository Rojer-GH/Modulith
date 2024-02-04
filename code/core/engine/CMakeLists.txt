# Engine CMakeLists

file(GLOB_RECURSE SOURCE_LIST CONFIGURE_DEPENDS "src/**.cpp" "src/**.h")
file(GLOB_RECURSE PUBLIC_HEADER_LIST CONFIGURE_DEPENDS "include/**.h")

add_library(ModulithEngine SHARED ${SOURCE_LIST} ${PUBLIC_HEADER_LIST})

# Copy VCPKG Includes
MODULITH_COPY_DIR_TO_MODDING(ModulithEngine ${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/include/ include/)

# Engine PB

set_target_properties(ModulithEngine PROPERTIES DEBUG_POSTFIX "")

# Engine Headers + Libraries
MODULITH_COPY_FILE_TO_MODDING(ModulithEngine $<TARGET_LINKER_FILE:ModulithEngine> ModulithEngine.lib)
MODULITH_COPY_DIR_TO_MODDING(ModulithEngine ${CMAKE_CURRENT_SOURCE_DIR}/include/ include/)
MODULITH_COPY_FILE_TO_OUTPUT(ModulithEngine $<TARGET_FILE:ModulithEngine> ModulithEngine.dll)

MODULITH_COPY_FILE_TO_MODDING(ModulithEngine $<TARGET_LINKER_FILE:${MODULITH_SPDLOG_TARGET}> ${MODULITH_SPDLOG}.lib)
MODULITH_COPY_FILE_TO_MODDING(ModulithEngine $<TARGET_LINKER_FILE:${MODULITH_CROSSGUID_TARGET}> ${MODULITH_CROSSGUID}.lib)
MODULITH_COPY_FILE_TO_MODDING(ModulithEngine $<TARGET_LINKER_FILE:${MODULITH_YAML-CPP_TARGET}> ${MODULITH_YAML-CPP}.lib)

target_precompile_headers(ModulithEngine PUBLIC include/PreCompiledHeader.h)

target_compile_definitions(ModulithEngine PRIVATE EXPORT_ENGINE)

target_link_libraries(ModulithEngine PUBLIC common ${MODULITH_GLM_TARGET} ${MODULITH_SPDLOG_TARGET} ${MODULITH_CROSSGUID_TARGET} ${MODULITH_YAML-CPP_TARGET})

target_include_directories(ModulithEngine PUBLIC include/ ${Stb_INCLUDE_DIR})
target_include_directories(ModulithEngine PRIVATE src/ platform/)