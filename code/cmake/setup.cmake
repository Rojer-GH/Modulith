# Pre-project configuration, like VCPKG

if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
    message(FATAL_ERROR "In-source builds are not allowed")
endif(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})

set(CMAKE_CXX_STANDARD 17)
add_compile_options(/MP)

set(SB_VCPKG_INSTALLED_DIR ${CMAKE_SOURCE_DIR}/libs)
set(CMAKE_TOOLCHAIN_FILE ${CMAKE_SOURCE_DIR}/vcpkg/scripts/buildsystems/vcpkg.cmake)
set(VCPKG_OVERLAY_PORTS ${CMAKE_SOURCE_DIR}/cmake/ports/)
set(VCPKG_OVERLAY_TRIPLETS ${CMAKE_SOURCE_DIR}/cmake/)
set(VCPKG_TARGET_TRIPLET modulith_triplet)