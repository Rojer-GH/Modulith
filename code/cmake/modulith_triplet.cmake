# Custom triplet file, needed to create shared libraries of imgui and PhysX

set(VCPKG_TARGET_ARCHITECTURE x64)

set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE static)

if(PORT MATCHES "imgui|physx")
    set(VCPKG_LIBRARY_LINKAGE dynamic)
endif()
