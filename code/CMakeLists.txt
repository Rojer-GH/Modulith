# Root CMakeLists
cmake_minimum_required(VERSION 3.16)

#[[
	Macro that wraps a call to include(), to check if the file exists. Additional values can be passed, which will be printed as error messages

	@param file: The file to include
]]
macro(include_throw_error FILE)
    include(
            ${FILE}
            RESULT_VARIABLE ${FILE}_file
    )
    if(${FILE} STREQUAL NOTFOUND)
        message(FATAL_ERROR "${FILE} not found! ${ARGN}")
    endif()
endmacro(include_throw_error)

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

include_throw_error(constants "The constants file was not found. It includes all the \"constants\" that are needed for project setup")

include_throw_error(setup "The setup code takes responsibility for the most basic settings")

project(${MODULITH_PROJECT_NAME}
        VERSION ${MODULITH_PROJECT_VERSION}
        DESCRIPTION ${MODULITH_PROJECT_DESCRIPTION}
        LANGUAGES ${MODULITH_PROJECT_LANGUAGES})

include_throw_error(functions "A file containing useful functions")

include_throw_error(packages "The packages-file contains all the external packages that are needed")

find_package(Doxygen)
if(Doxygen_FOUND)
    add_subdirectory(docs)
else()
    message(STATUS "Doxygen not found, not building docs")
endif()

add_library(common INTERFACE)

target_compile_definitions(common INTERFACE GLM_ENABLE_EXPERIMENTAL)

add_subdirectory(core)
add_subdirectory(modules)
#add_subdirectory(extern)
