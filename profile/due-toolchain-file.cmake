set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_CROSSCOMPILING 1)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(CAN_USE_ASSEMBLER TRUE)

if(NOT DEFINED ENV{CONAN_CMAKE_FIND_ROOT_PATH})
    message(FATAL_ERROR "You must set CONAN_CMAKE_FIND_ROOT_PATH in the conan profile")
endif()

# Include/link arm directories
include_directories("${ARM_TOOLCHAIN}/arm-none-eabi/include")
link_directories("${ARM_TOOLCHAIN}/arm-none-eabi/lib")

# General compiler flags
set(CMAKE_FLAGS "-g -Os -w  -ffunction-sections -fdata-sections -nostdlib --param max-inline-insns-single=500 -MMD -mcpu=cortex-m3 -mthumb")
# Add flags for C++
set(CMAKE_CXX_FLAGS "${CMAKE_FLAGS} -std=gnu++11 -fno-threadsafe-statics -fno-rtti -fno-exceptions") 
# Add flags for C
set(CMAKE_C_FLAGS "${CMAKE_FLAGS} -std=gnu11 -Dprintf=iprintf")
# Set flags for ASM
set(CMAKE_ASM_FLAGS "-c -g -x assembler-with-cpp -MMD -mcpu=cortex-m3 -mthumb")
# Set flags for linker
set (CMAKE_EXE_LINKER_FLAGS "-mcpu=cortex-m3 -mthumb -Os -lm -lgcc")

# Set compilers
find_program(CMAKE_C_COMPILER   NAMES arm-none-eabi-gcc)
message("Found C compiler: ${CMAKE_C_COMPILER}")
find_program(CMAKE_CXX_COMPILER NAMES arm-none-eabi-g++)
message("Found CXX compiler: ${CMAKE_CXX_COMPILER}")
set(CMAKE_ASM_COMPILER ${CMAKE_C_COMPILER})
set(CMAKE_LINKER ${CMAKE_C_COMPILER})

set(CMAKE_CXX_LINK_EXECUTABLE "<CMAKE_LINKER> -Wl,-Map,<TARGET>.map <CMAKE_CXX_LINK_FLAGS> -o <TARGET>.elf -Wl,--start-group <LINK_FLAGS> <OBJECTS> <LINK_LIBRARIES> -Wl,--end-group")
# Definitions for Aruino Due
add_compile_definitions(F_CPU=84000000L 
                        ARDUINO=10809 
                        ARDUINO_SAM_DUE 
                        ARDUINO_ARCH_SAM 
                        __SAM3X8E__ 
                        USB_VID=0x2341
                        USB_PID=0x003e 
                        USBCON 
                        USB_MANUFACTURER="Arduino LLC"
                        USB_PRODUCT="Arduino Due")
