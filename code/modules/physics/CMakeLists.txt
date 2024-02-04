MODULITH_INIT_MODULE(Physics)
MODULITH_LINK_TO_MODULES(Physics Core)

target_include_directories(Physics PRIVATE ../../extern/PhysX/physx/include)
target_include_directories(Physics PRIVATE ../../extern/PhysX/pxshared/include)

target_link_libraries(Physics PRIVATE
        "${PROJECT_SOURCE_DIR}/prebuilt/$<CONFIG>/PhysXCommon_64.lib"
        "${PROJECT_SOURCE_DIR}/prebuilt/$<CONFIG>/PhysX_64.lib"
        "${PROJECT_SOURCE_DIR}/prebuilt/$<CONFIG>/PhysXFoundation_64.lib"
        "${PROJECT_SOURCE_DIR}/prebuilt/$<CONFIG>/SampleBase_static_64.lib"
        "${PROJECT_SOURCE_DIR}/prebuilt/$<CONFIG>/PhysXExtensions_static_64.lib"
        "${PROJECT_SOURCE_DIR}/prebuilt/$<CONFIG>/PhysXCharacterKinematic_static_64.lib"
        "${PROJECT_SOURCE_DIR}/prebuilt/$<CONFIG>/PhysXPvdSDK_static_64.lib"
)
