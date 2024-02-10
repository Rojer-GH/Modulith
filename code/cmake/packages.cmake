# The configuration of the VCPKG packages

# Create two variables for every package, the name to reference and the target name
# Also "finds" the packages
function(MODULITH_CREATE_PACKAGE_FUNCTIONS_AND_CONFIGURE)
    foreach(package IN ITEMS ${ARGN})
        if(${package} MATCHES ":")
            string(REPLACE "::" ";" separated "${package}")
            LIST(GET separated 0 package_name)
            LIST(GET separated 1 only_target_name)
            set(target_name ${package_name}::${only_target_name})
        else()
            set(package_name ${package})
            set(target_name ${package})
        endif()
        string(TOUPPER ${package_name} name_upper)
        set(MODULITH_${name_upper} ${package_name} PARENT_SCOPE)
        set(MODULITH_${name_upper}_TARGET ${target_name} PARENT_SCOPE)
        find_package(${package_name} CONFIG REQUIRED)
    endforeach ()
endfunction()

# Load the packages
MODULITH_CREATE_PACKAGE_FUNCTIONS_AND_CONFIGURE(
        assimp::assimp
        crossguid
        fmt::fmt
        glad::glad
        glfw3
        glm::glm
        imgui::imgui
        spdlog::spdlog
        yaml-cpp::yaml-cpp
)

# Manually create the PhysX variables, as they cannot be found by the upper method

include_throw_error(FindPhysX "The FindPhysX file is needed, to load PhysX")
set(MODULITH_PHYSX PhysX)
set(MODULITH_PHYSX_TARGET PhysX::PhysX)

get_target_property(INC ${MODULITH_IMGUI_TARGET} INTERFACE_INCLUDE_DIRECTORIES)
message("TEST: " ${INC})

# STB has not real target

set(MODULITH_STB Stb)
find_package(${MODULITH_STB} REQUIRED)