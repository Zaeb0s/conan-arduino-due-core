cmake_minimum_required(VERSION 3.7.2)
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_CROSSCOMPILING 1)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(CAN_USE_ASSEMBLER TRUE)

if(WIN32)
    set(EXECUTABLE_SUFFIX ".exe") # Used in find_program (seems to be required for windows 7)
    message("Setting executable suffix for find_program: ${EXECUTABLE_SUFFIX}")
else()
    set(EXECUTABLE_SUFFIX "")
endif()
# =============================== Set flags ===============================
# Add flags for C++
set(CMAKE_CXX_FLAGS         "-c -g -Os -w -std=gnu++11 -ffunction-sections -fdata-sections -nostdlib -fno-threadsafe-statics --param max-inline-insns-single=500 -fno-rtti -fno-exceptions -MMD -mcpu=cortex-m3 -mthumb" CACHE STRING "")  
set(CMAKE_CXX_FLAGS_DEBUG   "" CACHE STRING "")
set(CMAKE_CXX_FLAGS_RELEASE "" CACHE STRING "")

set(CMAKE_CXX_FLAGS         ${CMAKE_CXX_FLAGS} CACHE STRING         "" FORCE)
set(CMAKE_CXX_FLAGS_DEBUG   ${CMAKE_CXX_FLAGS_DEBUG} CACHE STRING   "" FORCE)
set(CMAKE_CXX_FLAGS_RELEASE ${CMAKE_CXX_FLAGS_RELEASE} CACHE STRING "" FORCE)

# Add flags for C
set(CMAKE_C_FLAGS         "-c -g -Os -w -std=gnu11 -ffunction-sections -fdata-sections -nostdlib --param max-inline-insns-single=500 -Dprintf=iprintf -MMD -mcpu=cortex-m3 -mthumb" CACHE STRING "")
set(CMAKE_C_FLAGS_DEBUG   "" CACHE STRING "")
set(CMAKE_C_FLAGS_RELEASE "" CACHE STRING "")
set(CMAKE_C_FLAGS           ${CMAKE_C_FLAGS} CACHE STRING           "" FORCE)
set(CMAKE_C_FLAGS_DEBUG     ${CMAKE_C_FLAGS_DEBUG} CACHE STRING     "" FORCE)
set(CMAKE_C_FLAGS_RELEASE   ${CMAKE_C_FLAGS_RELEASE} CACHE STRING   "" FORCE)

# Set flags for ASM
set(CMAKE_ASM_FLAGS         "-c -g -x assembler-with-cpp -MMD -mcpu=cortex-m3 -mthumb" CACHE STRING "")
set(CMAKE_ASM_FLAGS_DEBUG   "" CACHE STRING "")
set(CMAKE_ASM_FLAGS_RELEASE "" CACHE STRING "")

set(CMAKE_ASM_FLAGS           ${CMAKE_ASM_FLAGS} CACHE STRING           "" FORCE)
set(CMAKE_ASM_FLAGS_DEBUG     ${CMAKE_ASM_FLAGS_DEBUG} CACHE STRING     "" FORCE)
set(CMAKE_ASM_FLAGS_RELEASE   ${CMAKE_ASM_FLAGS_RELEASE} CACHE STRING   "" FORCE)

# Set flags for linker1
set(CMAKE_EXE_LINKER_FLAGS "-mcpu=cortex-m3 -mthumb -Os -Wl,--gc-sections -Wl,--warn-common -Wl,--warn-section-align" CACHE STRING "")
set(CMAKE_EXE_LINKER_FLAGS ${CMAKE_EXE_LINKER_FLAGS} CACHE STRING "" FORCE)
# Definitions for Aruino Due
add_definitions(-DF_CPU=84000000L 
                -DARDUINO=10809 
                -DARDUINO_SAM_DUE 
                -DARDUINO_ARCH_SAM 
                -D__SAM3X8E__ 
                -DUSB_VID=0x2341
                -DUSB_PID=0x003e 
                -DUSBCON 
                -DUSB_MANUFACTURER="Arduino LLC"
                -DUSB_PRODUCT="Arduino Due")
           
# =============================== Set compilers ===============================
find_program(CMAKE_C_COMPILER NAMES "arm-none-eabi-gcc${EXECUTABLE_SUFFIX}")
if (NOT CMAKE_C_COMPILER)
    message(FATAL_ERROR "C compiler \"arm-none-eabi-gcc\" not found!")
else()
    message("Found C compiler: ${CMAKE_C_COMPILER}")
endif()

find_program(CMAKE_CXX_COMPILER NAMES "arm-none-eabi-g++${EXECUTABLE_SUFFIX}")
if (NOT CMAKE_CXX_COMPILER)
    message(FATAL_ERROR "CXX compiler \"arm-none-eabi-g++\" not found!")
else()
    message("Found CXX compiler: ${CMAKE_CXX_COMPILER}")
endif()

find_program(CMAKE_AR NAMES "arm-none-eabi-ar${EXECUTABLE_SUFFIX}")
if (NOT CMAKE_AR)
    message(FATAL_ERROR "Archiver \"arm-none-eabi-ar\" not found!")
else()
    message("Found archiver: ${CMAKE_AR}")
endif()

set(CMAKE_ASM_COMPILER ${CMAKE_C_COMPILER})
set(CMAKE_LINKER ${CMAKE_C_COMPILER})

# ============================= Configure compile steps =======================
set(CMAKE_CXX_LINK_EXECUTABLE "<CMAKE_LINKER> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> -Wl,--cref -Wl,--check-sections -Wl,--gc-sections -Wl,--unresolved-symbols=report-all -Wl,--warn-common -Wl,--warn-section-align -Wl,-Map,<TARGET>.map -o <TARGET>.elf -Wl,--start-group <OBJECTS> <LINK_LIBRARIES> -Wl,--end-group -lm -lgcc")
set(CMAKE_C_LINK_EXECUTABLE   "<CMAKE_LINKER> <CMAKE_C_LINK_FLAGS>   <LINK_FLAGS> -Wl,--cref -Wl,--check-sections -Wl,--gc-sections -Wl,--unresolved-symbols=report-all -Wl,--warn-common -Wl,--warn-section-align -Wl,-Map,<TARGET>.map -o <TARGET>.elf -Wl,--start-group <OBJECTS> <LINK_LIBRARIES> -Wl,--end-group -lm -lgcc")
set(CMAKE_ASM_LINK_EXECUTABLE "<CMAKE_LINKER> <CMAKE_ASM_LINK_FLAGS> <LINK_FLAGS> -Wl,--cref -Wl,--check-sections -Wl,--gc-sections -Wl,--unresolved-symbols=report-all -Wl,--warn-common -Wl,--warn-section-align -Wl,-Map,<TARGET>.map -o <TARGET>.elf -Wl,--start-group <OBJECTS> <LINK_LIBRARIES> -Wl,--end-group -lm -lgcc")

set(CMAKE_CXX_COMPILE_OBJECT "<CMAKE_CXX_COMPILER> <FLAGS> <DEFINES> <INCLUDES> <SOURCE> -o <OBJECT>") 
set(CMAKE_C_COMPILE_OBJECT   "<CMAKE_C_COMPILER>   <FLAGS> <DEFINES> <INCLUDES> <SOURCE> -o <OBJECT>") 
set(CMAKE_ASM_COMPILE_OBJECT "<CMAKE_ASM_COMPILER> <FLAGS> <DEFINES> <INCLUDES> <SOURCE> -o <OBJECT>") 

set(CMAKE_CXX_CREATE_STATIC_LIBRARY "<CMAKE_AR> rcs <TARGET> <OBJECTS>")
set(CMAKE_C_CREATE_STATIC_LIBRARY   "<CMAKE_AR> rcs <TARGET> <OBJECTS>")
set(CMAKE_ASM_CREATE_STATIC_LIBRARY "<CMAKE_AR> rcs <TARGET> <OBJECTS>")

# ============================ Macros =======================================

macro(_generate_object target)
    find_program(CMAKE_OBJCOPY NAMES "arm-none-eabi-objcopy${EXECUTABLE_SUFFIX}")
    if (NOT CMAKE_OBJCOPY)
        message(FATAL_ERROR "Objcopy \"arm-none-eabi-objcopy\" not found!")
    else()
        message("Found objcopy: ${CMAKE_OBJCOPY}")
    endif()

    add_custom_command(TARGET ${target} POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -O binary
        "${CMAKE_CURRENT_BINARY_DIR}/bin/${target}.elf" "${CMAKE_CURRENT_BINARY_DIR}/bin/${target}.bin"
    )
endmacro()

macro(_firmware_size target)
    find_program(CMAKE_SIZE_UTIL NAMES "arm-none-eabi-size${EXECUTABLE_SUFFIX}")
    if (NOT CMAKE_SIZE_UTIL)
        message(FATAL_ERROR "\"arm-none-eabi-size\" not found!")
    else()
        message("Found arm-none-eabi-size: ${CMAKE_SIZE_UTIL}")
    endif()

    add_custom_command(TARGET ${target} POST_BUILD
        COMMAND ${CMAKE_SIZE_UTIL} -B
        "${CMAKE_CURRENT_BINARY_DIR}/bin/${target}.elf"
    )
endmacro()
