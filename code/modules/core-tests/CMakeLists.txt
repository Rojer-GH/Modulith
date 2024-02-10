# Tests CMakeLists

file(GLOB_RECURSE SOURCE_LIST CONFIGURE_DEPENDS "src/**.cpp" "src/**.h")

add_executable(ModulithCoreTests ${SOURCE_LIST})

target_include_directories(ModulithCoreTests PRIVATE ${MODULITH_VCPKG_INCLUDE} "src/")
target_link_libraries(ModulithCoreTests PRIVATE ModulithEngine ${MODULITH_CORE_TARGET} common)

#add_custom_command(TARGET ModulithCoreTests POST_BUILD
#    COMMAND ${CMAKE_COMMAND} -E copy_if_different $<TARGET_FILE:ModulithEngine> ${CMAKE_CURRENT_BINARY_DIR}/ModulithEngine.dll
#)

#add_custom_command(TARGET ModulithCoreTests POST_BUILD
#    COMMAND ${CMAKE_COMMAND} -E copy_if_different $<TARGET_FILE:Core> ${CMAKE_CURRENT_BINARY_DIR}/Core.dll
#)

#add_custom_command(TARGET ModulithCoreTests POST_BUILD
#    COMMAND ${CMAKE_COMMAND} -E copy_if_different $<TARGET_FILE:imgui> ${CMAKE_CURRENT_BINARY_DIR}/imgui.dll
#)