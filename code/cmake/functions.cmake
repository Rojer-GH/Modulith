# Copy Files
macro(MODULITH_COPY_FILE_TO_LOCATION TARGET INPUT OUTPUT LOCATION)
    add_custom_command(TARGET ${TARGET} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different ${INPUT} ${LOCATION}/${OUTPUT}
    )
endmacro(MODULITH_COPY_FILE_TO_LOCATION TARGET INPUT OUTPUT LOCATION)

macro(MODULITH_COPY_FILE_TO_OUTPUT TARGET INPUT OUTPUT)
    MODULITH_COPY_FILE_TO_LOCATION(${TARGET} ${INPUT} ${OUTPUT} ${MODULITH_OUTPUT_DIRECTORY})
endmacro(MODULITH_COPY_FILE_TO_OUTPUT TARGET INPUT OUTPUT)

macro(MODULITH_COPY_FILE_TO_MODDING TARGET INPUT OUTPUT)
    MODULITH_COPY_FILE_TO_LOCATION(${TARGET} ${INPUT} ${OUTPUT} ${MODULITH_MODDING_DIRECTORY})
endmacro(MODULITH_COPY_FILE_TO_MODDING TARGET INPUT OUTPUT)

macro(MODULITH_COPY_FILE_TO_MODULES TARGET INPUT OUTPUT)
    MODULITH_COPY_FILE_TO_LOCATION(${TARGET} ${INPUT} ${OUTPUT} ${MODULITH_MODULES_DIRECTORY})
endmacro(MODULITH_COPY_FILE_TO_MODULES TARGET INPUT OUTPUT)

macro(MODULITH_COPY_DIR_TO_LOCATION TARGET INPUT OUTPUT LOCATION)
    add_custom_command(TARGET ${TARGET} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_directory ${INPUT} ${LOCATION}/${OUTPUT}
    )
endmacro(MODULITH_COPY_DIR_TO_LOCATION TARGET INPUT OUTPUT LOCATION)

macro(MODULITH_COPY_DIR_TO_OUTPUT TARGET INPUT OUTPUT)
    MODULITH_COPY_DIR_TO_LOCATION(${TARGET} ${INPUT} ${OUTPUT} ${MODULITH_OUTPUT_DIRECTORY})
endmacro(MODULITH_COPY_DIR_TO_OUTPUT TARGET INPUT OUTPUT)

macro(MODULITH_COPY_DIR_TO_MODDING TARGET INPUT OUTPUT)
    MODULITH_COPY_DIR_TO_LOCATION(${TARGET} ${INPUT} ${OUTPUT} ${MODULITH_MODDING_DIRECTORY})
endmacro(MODULITH_COPY_DIR_TO_MODDING TARGET INPUT OUTPUT)

macro(MODULITH_COPY_DIR_TO_MODULES TARGET INPUT OUTPUT)
    MODULITH_COPY_DIR_TO_LOCATION(${TARGET} ${INPUT} ${OUTPUT} ${MODULITH_MODULES_DIRECTORY})
endmacro(MODULITH_COPY_DIR_TO_MODULES TARGET INPUT OUTPUT)

macro(MODULITH_INIT_MODULE NAME)
    set(LinkingDependencies ModulithEngine
            #${MODULITH_SPDLOG}
            ${MODULITH_CROSSGUID}
            ${MODULITH_YAML_CPP})

    file(GLOB_RECURSE SourceList CONFIGURE_DEPENDS "src/**.cpp" "src/**.h")

    add_library(${NAME} SHARED ${SourceList})

    set_target_properties(${NAME} PROPERTIES DEBUG_POSTFIX "")

    target_precompile_headers(${NAME} PRIVATE "${MODULITH_MODDING_DIRECTORY}/include/PreCompiledHeader.h" "include/ModulithPreCompiledHeader.h")

    string(TIMESTAMP NOW "%Y-%m-%d %H-%M-%S")
    set_target_properties(${NAME} PROPERTIES PDB_NAME "${NAME} ${NOW}")

    target_include_directories(${NAME} PUBLIC ${MODULITH_MODDING_DIRECTORY}/include/)
    target_include_directories(${NAME} PUBLIC include/ ${Stb_INCLUDE_DIR})
    target_include_directories(${NAME} PRIVATE src/)

    foreach(toLink IN ITEMS ${LinkingDependencies})
        target_link_libraries(${NAME} PRIVATE "${MODULITH_MODDING_DIRECTORY}/${toLink}.lib")
    endforeach()

    target_link_libraries(${NAME} PUBLIC common ${MODULITH_FMT_TARGET})

    MODULITH_COPY_FILE_TO_MODULES(${NAME} $<TARGET_FILE:${NAME}> ${NAME}/${NAME}_hotloadable.dll)
    MODULITH_COPY_FILE_TO_MODULES(${NAME} $<TARGET_LINKER_FILE:${NAME}>
            ${NAME}/modding/${NAME}.lib)

    if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/include/)
        MODULITH_COPY_DIR_TO_MODULES(${NAME} ${CMAKE_CURRENT_SOURCE_DIR}/include/ ${NAME}/modding/include/)
    endif()

    target_compile_definitions(${NAME} PRIVATE EXPORT_$<UPPER_CASE:${NAME}>_MODULE)
endmacro(MODULITH_INIT_MODULE NAME)

macro(MODULITH_LINK_TO_MODULES NAME)
    foreach(dependency IN ITEMS ${ARGN})
        file(GLOB ModuleLinkingDependencies CONFIGURE_DEPENDS "${MODULITH_MODULES_DIRECTORY}/${dependency}/modding/**.lib")
        foreach(toLink IN ITEMS ${ModuleLinkingDependencies})
            target_link_libraries(${NAME} PRIVATE ${${toLink}_TARGET})
        endforeach()
        target_include_directories(${NAME} PRIVATE ${MODULITH_MODULES_DIRECTORY}/${dependency}/modding/include/)
    endforeach()
endmacro(MODULITH_LINK_TO_MODULES NAME)

macro(MODULITH_LINK_TO_LIBS NAME TYPE)
    foreach(toLink IN ITEMS ${ARGN})
        target_link_libraries(${NAME} ${TYPE} ${MODULITH_${toLink}_TARGET})
        #MODULITH_COPY_FILE_TO_MODULES(${NAME} $<TARGET_FILE:${MODULITH_${toLink}_TARGET}>
        #        ${NAME}/${MODULITH_${toLink}}.dll)
        #MODULITH_COPY_FILE_TO_MODULES(${NAME} $<TARGET_LINKER_FILE:${MODULITH_${toLink}_TARGET}>
        #        ${NAME}/modding/${MODULITH_${toLink}}.lib)
    endforeach()
endmacro(MODULITH_LINK_TO_LIBS NAME)