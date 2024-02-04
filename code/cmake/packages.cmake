# Setup packages

#set(MODULITH_ASSIMP assimp)
#set(MODULITH_CROSSGUID crossguid)
#set(MODULITH_FMT fmt)
#set(MODULITH_GLAD glad)
#set(MODULITH_GLFW3 glfw3)
#set(MODULITH_GLM glm)
#set(MODULITH_IMGUI imgui)
#set(MODULITH_SPDLOG spdlog)
set(MODULITH_STB Stb)
#set(MODULITH_YAML_CPP yaml-cpp)

#find_package(${MODULITH_ASSIMP} REQUIRED)
#find_package(${MODULITH_CROSSGUID} CONFIG REQUIRED)
#find_package(${MODULITH_GLAD} REQUIRED)
#find_package(${MODULITH_GLFW3} REQUIRED)
#find_package(${MODULITH_GLM} CONFIG REQUIRED)
#find_package(${MODULITH_IMGUI} CONFIG REQUIRED)
#find_package(physx REQUIRED)
#find_package(${MODULITH_SPDLOG} CONFIG REQUIRED)
find_package(${MODULITH_STB} REQUIRED)
#find_package(${MODULITH_YAML_CPP} CONFIG REQUIRED)
#find_package(${MODULITH_FMT} REQUIRED)

function(MODULITH_CREATE_PACKAGE_FUNCTIONS_AND_INITIALIZE)
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

MODULITH_CREATE_PACKAGE_FUNCTIONS_AND_INITIALIZE(
        assimp::assimp
        crossguid
        fmt::fmt
        glad::glad
        glfw3
        glm::glm
        imgui::imgui
        #OpenGL::OpenGL
        spdlog::spdlog
        yaml-cpp::yaml-cpp
)

find_package(OpenGL REQUIRED COMPONENTS OpenGL
)

message("COOL " ${OPENGL_LIBRARY})

set(MODULITH_OPENGL OpenGL)
set(MODULITH_OPENGL_TARGET opengl32)
