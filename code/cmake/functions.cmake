# Copy a filee to a target location, after the building process of the given target is done
macro(MODULITH_COPY_FILE_TO_LOCATION TARGET INPUT OUTPUT LOCATION)
    add_custom_command(TARGET ${TARGET} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different ${INPUT} ${LOCATION}/${OUTPUT}
    )
endmacro(MODULITH_COPY_FILE_TO_LOCATION TARGET INPUT OUTPUT LOCATION)

# Copy a file to the output directory
macro(MODULITH_COPY_FILE_TO_OUTPUT TARGET INPUT OUTPUT)
    MODULITH_COPY_FILE_TO_LOCATION(${TARGET} ${INPUT} ${OUTPUT} ${MODULITH_OUTPUT_DIRECTORY})
endmacro(MODULITH_COPY_FILE_TO_OUTPUT TARGET INPUT OUTPUT)

# Copy a file to the modding directory
macro(MODULITH_COPY_FILE_TO_MODDING TARGET INPUT OUTPUT)
    MODULITH_COPY_FILE_TO_LOCATION(${TARGET} ${INPUT} ${OUTPUT} ${MODULITH_MODDING_DIRECTORY})
endmacro(MODULITH_COPY_FILE_TO_MODDING TARGET INPUT OUTPUT)

# Copy a file to the modules directory
macro(MODULITH_COPY_FILE_TO_MODULES TARGET INPUT OUTPUT)
    MODULITH_COPY_FILE_TO_LOCATION(${TARGET} ${INPUT} ${OUTPUT} ${MODULITH_MODULES_DIRECTORY})
endmacro(MODULITH_COPY_FILE_TO_MODULES TARGET INPUT OUTPUT)

# Copy a directory to a target location, after the building process of the given target is done
macro(MODULITH_COPY_DIR_TO_LOCATION TARGET INPUT OUTPUT LOCATION)
    add_custom_command(TARGET ${TARGET} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_directory ${INPUT} ${LOCATION}/${OUTPUT}
    )
endmacro(MODULITH_COPY_DIR_TO_LOCATION TARGET INPUT OUTPUT LOCATION)

# Copy a directory to the output directory
macro(MODULITH_COPY_DIR_TO_OUTPUT TARGET INPUT OUTPUT)
    MODULITH_COPY_DIR_TO_LOCATION(${TARGET} ${INPUT} ${OUTPUT} ${MODULITH_OUTPUT_DIRECTORY})
endmacro(MODULITH_COPY_DIR_TO_OUTPUT TARGET INPUT OUTPUT)

# Copy a directory to the modding directory
macro(MODULITH_COPY_DIR_TO_MODDING TARGET INPUT OUTPUT)
    MODULITH_COPY_DIR_TO_LOCATION(${TARGET} ${INPUT} ${OUTPUT} ${MODULITH_MODDING_DIRECTORY})
endmacro(MODULITH_COPY_DIR_TO_MODDING TARGET INPUT OUTPUT)

# Copy a directory to the modules directory
macro(MODULITH_COPY_DIR_TO_MODULES TARGET INPUT OUTPUT)
    MODULITH_COPY_DIR_TO_LOCATION(${TARGET} ${INPUT} ${OUTPUT} ${MODULITH_MODULES_DIRECTORY})
endmacro(MODULITH_COPY_DIR_TO_MODULES TARGET INPUT OUTPUT)

# Create the module target
macro(MODULITH_INIT_MODULE NAME)
    # Basic module configuration
    file(GLOB_RECURSE SourceList CONFIGURE_DEPENDS "src/**.cpp" "src/**.h")
    add_library(${NAME} SHARED ${SourceList})
    set_target_properties(${NAME} PROPERTIES DEBUG_POSTFIX "")
    target_precompile_headers(${NAME} PRIVATE "${MODULITH_MODDING_DIRECTORY}/include/PreCompiledHeader.h" "include/ModulithPreCompiledHeader.h")

    # So one can check for the up-to-dateness of the built module
    string(TIMESTAMP NOW "%Y-%m-%d %H-%M-%S")
    set_target_properties(${NAME} PROPERTIES PDB_NAME "${NAME} ${NOW}")

    # Includes its own directory 2 times...
    target_include_directories(${NAME} PRIVATE ${MODULITH_MODDING_DIRECTORY}/include/)
    target_include_directories(${NAME} PRIVATE include/ ${Stb_INCLUDE_DIR})
    target_include_directories(${NAME} PRIVATE src/)

    # Link against the built libraries in the output directory
    set(LinkingDependencies ModulithEngine
            ${MODULITH_SPDLOG}
            ${MODULITH_CROSSGUID}
            ${MODULITH_YAML-CPP}
            ${MODULITH_FMT}
    )
    foreach(toLink IN ITEMS ${LinkingDependencies})
        target_link_libraries(${NAME} PRIVATE "${MODULITH_MODDING_DIRECTORY}/${toLink}.lib")
    endforeach()

    # For defines
    target_link_libraries(${NAME} PRIVATE common)

    # Copy over linker file and library file to the output directory
    MODULITH_COPY_FILE_TO_MODULES(${NAME} $<TARGET_FILE:${NAME}> ${NAME}/${NAME}_hotloadable.dll)
    MODULITH_COPY_FILE_TO_MODULES(${NAME} $<TARGET_LINKER_FILE:${NAME}>
            ${NAME}/modding/${NAME}.lib)

    # Also copy the include directory, if it exists
    if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/include/)
        MODULITH_COPY_DIR_TO_MODULES(${NAME} ${CMAKE_CURRENT_SOURCE_DIR}/include/ ${NAME}/modding/include/)
    endif()

    # Export the symbols
    target_compile_definitions(${NAME} PRIVATE EXPORT_$<UPPER_CASE:${NAME}>_MODULE)
endmacro(MODULITH_INIT_MODULE NAME)

# Link a module to another module
macro(MODULITH_LINK_TO_MODULES NAME)
    # For every module, get the list of linker files in their modding directories, and link against them.
    # Also, add their "include" folder to the modules include directories
    foreach(dependency IN ITEMS ${ARGN})
        file(GLOB ModuleLinkingDependencies CONFIGURE_DEPENDS "${MODULITH_MODULES_DIRECTORY}/${dependency}/modding/**.lib")
        foreach(toLink IN ITEMS ${ModuleLinkingDependencies})
            target_link_libraries(${NAME} PRIVATE ${toLink})
        endforeach()
        target_include_directories(${NAME} PUBLIC ${MODULITH_MODULES_DIRECTORY}/${dependency}/modding/include/)
    endforeach()
endmacro(MODULITH_LINK_TO_MODULES NAME)

# Link a module to VCPKG packages
function(MODULITH_LINK_TO_LIBS NAME VISIBILITY)
    function(MODULITH_COPY_LIBS_IF_NEEDED LIB)
        get_target_property(TARGET_TYPE ${LIB} TYPE)
        if(TARGET_TYPE STREQUAL "SHARED_LIBRARY")
            MODULITH_COPY_FILE_TO_MODULES(${NAME} $<TARGET_FILE:${LIB}> ${NAME}/$<TARGET_FILE_NAME:${LIB}>)
            if(${VISIBILITY} STREQUAL "PUBLIC")
                MODULITH_COPY_FILE_TO_MODULES(${NAME} $<TARGET_LINKER_FILE:${LIB}> ${NAME}/modding/$<TARGET_LINKER_FILE_NAME:${LIB}>)
            endif()
        elseif(TARGET_TYPE STREQUAL "INTERFACE_LIBRARY")
            get_target_property(SUBLIBS ${LIB} INTERFACE_LINK_LIBRARIES)
            foreach(SUBLIB IN ITEMS ${SUBLIBS})
                MODULITH_COPY_LIBS_IF_NEEDED(${SUBLIB})
            endforeach()
        endif()
    endfunction(MODULITH_COPY_LIBS_IF_NEEDED LIB)

    foreach(toLink IN ITEMS ${ARGN})
        # Link against the package, and check for the type
        # Static libraries only need to be linked against
        target_link_libraries(${NAME} ${VISIBILITY} ${MODULITH_${toLink}_TARGET})
        MODULITH_COPY_LIBS_IF_NEEDED(${MODULITH_${toLink}_TARGET})
    endforeach()
endfunction(MODULITH_LINK_TO_LIBS NAME VISIBILITY)