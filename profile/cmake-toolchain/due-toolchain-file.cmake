set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_CROSSCOMPILING 1)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(CAN_USE_ASSEMBLER TRUE)

# =============================== Set flags ===============================
# Add flags for C++
set(CMAKE_CXX_FLAGS "-c -g -Os -w -std=gnu++11 -ffunction-sections -fdata-sections -nostdlib -fno-threadsafe-statics --param max-inline-insns-single=500 -fno-rtti -fno-exceptions -MMD -mcpu=cortex-m3 -mthumb") 
set(CMAKE_CXX_FLAGS_DEBUG "")
set(CMAKE_CXX_FLAGS_RELEASE "")
# Add flags for C
set(CMAKE_C_FLAGS "-c -g -Os -w -std=gnu11 -ffunction-sections -fdata-sections -nostdlib --param max-inline-insns-single=500 -Dprintf=iprintf -MMD -mcpu=cortex-m3 -mthumb")
set(CMAKE_C_FLAGS_DEBUG "")
set(CMAKE_C_FLAGS_RELEASE "")
# Set flags for ASM
set(CMAKE_ASM_FLAGS "-c -g -x assembler-with-cpp -MMD -mcpu=cortex-m3 -mthumb")
set(CMAKE_ASM_FLAGS_DEBUG "")
set(CMAKE_ASM_FLAGS_RELEASE "")
# Set flags for linker
set (CMAKE_EXE_LINKER_FLAGS "-mcpu=cortex-m3 -mthumb -Os -Wl,--gc-sections -Wl,--warn-common -Wl,--warn-section-align")
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
           
# =============================== Set compilers ===============================
find_program(CMAKE_C_COMPILER NAMES arm-none-eabi-gcc)
if (NOT CMAKE_C_COMPILER)
    message(FATAL_ERROR "C compiler \"arm-none-eabi-gcc\" not found!")
else()
    message("Found C compiler: ${CMAKE_C_COMPILER}")
endif()

find_program(CMAKE_CXX_COMPILER NAMES arm-none-eabi-g++)
if (NOT CMAKE_CXX_COMPILER)
    message(FATAL_ERROR "CXX compiler \"arm-none-eabi-g++\" not found!")
else()
    message("Found CXX compiler: ${CMAKE_CXX_COMPILER}")
endif()

find_program(CMAKE_AR NAMES arm-none-eabi-ar)
if (NOT CMAKE_AR)
    message(FATAL_ERROR "Archiver \"arm-none-eabi-ar\" not found!")
else()
    message("Found archiver: ${CMAKE_AR}")
endif()

set(CMAKE_ASM_COMPILER ${CMAKE_C_COMPILER})
set(CMAKE_LINKER ${CMAKE_C_COMPILER})

# ============================= Configure compile steps =======================
set(CMAKE_CXX_LINK_EXECUTABLE "<CMAKE_LINKER> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> -Wl,--cref -Wl,--check-sections -Wl,--gc-sections -Wl,--unresolved-symbols=report-all -Wl,--warn-common -Wl,--warn-section-align -Wl,-Map,<TARGET>.map -o <TARGET>.elf -Wl,--start-group <OBJECTS> <LINK_LIBRARIES> -Wl,--end-group -lm -lgcc")
set(CMAKE_C_LINK_EXECUTABLE "<CMAKE_LINKER> <CMAKE_C_LINK_FLAGS> <LINK_FLAGS> -Wl,--cref -Wl,--check-sections -Wl,--gc-sections -Wl,--unresolved-symbols=report-all -Wl,--warn-common -Wl,--warn-section-align -Wl,-Map,<TARGET>.map -o <TARGET>.elf -Wl,--start-group <OBJECTS> <LINK_LIBRARIES> -Wl,--end-group -lm -lgcc")
set(CMAKE_ASM_LINK_EXECUTABLE "<CMAKE_LINKER> <CMAKE_ASM_LINK_FLAGS> <LINK_FLAGS> -Wl,--cref -Wl,--check-sections -Wl,--gc-sections -Wl,--unresolved-symbols=report-all -Wl,--warn-common -Wl,--warn-section-align -Wl,-Map,<TARGET>.map -o <TARGET>.elf -Wl,--start-group <OBJECTS> <LINK_LIBRARIES> -Wl,--end-group -lm -lgcc")

set(CMAKE_CXX_COMPILE_OBJECT "<CMAKE_CXX_COMPILER> <FLAGS> <DEFINES> <INCLUDES> <SOURCE> -o <OBJECT>") 
set(CMAKE_C_COMPILE_OBJECT "<CMAKE_C_COMPILER> <FLAGS> <DEFINES> <INCLUDES> <SOURCE> -o <OBJECT>") 
set(CMAKE_ASM_COMPILE_OBJECT "<CMAKE_ASM_COMPILER> <FLAGS> <DEFINES> <INCLUDES> <SOURCE> -o <OBJECT>") 

set(CMAKE_CXX_CREATE_STATIC_LIBRARY "<CMAKE_AR> rcs <TARGET> <OBJECTS>")
set(CMAKE_C_CREATE_STATIC_LIBRARY   "<CMAKE_AR> rcs <TARGET> <OBJECTS>")
set(CMAKE_ASM_CREATE_STATIC_LIBRARY "<CMAKE_AR> rcs <TARGET> <OBJECTS>")

# ============================ Macros =======================================

macro(_generate_object target)
    find_program(CMAKE_OBJCOPY NAMES arm-none-eabi-objcopy)
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
    find_program(CMAKE_SIZE_UTIL NAMES arm-none-eabi-size)
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
