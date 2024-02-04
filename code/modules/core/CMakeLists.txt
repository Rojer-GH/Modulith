# ======================================================================================================================
# CORE MODULE CMAKE LIST
# ======================================================================================================================

# ----------------------------------------------------------------------------------------------------------------------
# TARGET VARIABLES: Configured Automatically, do not change!
# ----------------------------------------------------------------------------------------------------------------------

MODULITH_INIT_MODULE(Core)
MODULITH_LINK_TO_LIBS(Core PRIVATE ASSIMP GLAD OPENGL)
MODULITH_LINK_TO_LIBS(Core PUBLIC IMGUI)

add_compile_definitions(Core PUBLIC GLFW_INCLUDE_NONE)

# ----------------------------------------------------------------------------------------------------------------------
# BLUEPRINT: Generated Automatically, the same for evsery module. Do not change!
# ----------------------------------------------------------------------------------------------------------------------


# ----------------------------------------------------------------------------------------------------------------------
# (Optional) TARGET-SPECIFIC CMAKE:
#       You can paste custom cmake commands below that should apply to this target.
#       It is recommended to use the target variables instead of direct names / paths
# ----------------------------------------------------------------------------------------------------------------------

#add_compile_definitions(GLFW_INCLUDE_NONE)
#target_compile_definitions(Core PUBLIC ASSIMP_BUILD_BOOST_WORKAROUND)

# ImGui Headers + Library

#add_custom_command(TARGET ${ModuleName} POST_BUILD
#        COMMAND ${CMAKE_COMMAND} -E copy_if_different
#${CMAKE_CURRENT_SOURCE_DIR}/../../extern/imgui/imgui.h
#${ModdingOutputDirectory}/include/imgui.h
#        )

#add_custom_command(TARGET ${ModuleName} POST_BUILD
#        COMMAND ${CMAKE_COMMAND} -E copy_if_different
#${CMAKE_CURRENT_SOURCE_DIR}/../../extern/imgui/imconfig.h
#${ModdingOutputDirectory}/include/imconfig.h
#        )

#add_custom_command(TARGET ${ModuleName} POST_BUILD
#        COMMAND ${CMAKE_COMMAND} -E copy_if_different
#$<TARGET_LINKER_FILE:imgui> ${ModdingOutputDirectory}/imgui.lib
#        )

#add_custom_command(TARGET ${ModuleName} POST_BUILD
#        COMMAND ${CMAKE_COMMAND} -E copy_if_different $<TARGET_FILE:imgui>
#${OutputDirectory}/imgui.dll
#        )