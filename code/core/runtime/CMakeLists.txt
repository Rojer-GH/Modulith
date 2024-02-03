# Runtime CMakeLists

add_executable(ModulithRuntime src/Runtime.cpp src/Runtime.h)

target_link_libraries(ModulithRuntime PRIVATE common ModulithEngine)

MODULITH_COPY_FILE_TO_OUTPUT(ModulithRuntime $<TARGET_FILE:ModulithRuntime> ModulithRuntime.exe)