set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_CROSSCOMPILING 1)

set(CMAKE_C_COMPILER_WORKS 1)
set(CMAKE_CXX_COMPILER_WORKS 1)
set(CMAKE_ASM_COMPILER_WORKS 1)

set(CAN_USE_ASSEMBLER TRUE)

set(ARM_NONE_EABI_TOOLCHAIN "C:/Users/chris/Documents/ArduinoData/packages/arduino/tools/arm-none-eabi-gcc/4.8.3-2014q1")

# Include/link arm directories
include_directories("${ARM_NONE_EABI_TOOLCHAIN}/arm-none-eabi/include")
link_directories("${ARM_NONE_EABI_TOOLCHAIN}/arm-none-eabi/lib")

# General compiler flags
set(CMAKE_FLAGS "-g -Os -w  -ffunction-sections -fdata-sections -nostdlib --param max-inline-insns-single=500 -MMD  -mcpu=cortex-m3 -mthumb")
# Add flags for C++
set(CMAKE_CXX_FLAGS "${CMAKE_FLAGS} -std=gnu++11 -fno-threadsafe-statics -fno-rtti -fno-exceptions") 
# Add flags for C
set(CMAKE_C_FLAGS "${CMAKE_FLAGS} -std=gnu11 -Dprintf=iprintf")
# Set flags for ASM
set(CMAKE_ASM_FLAGS "-c -g -x assembler-with-cpp -MMD -mcpu=cortex-m3 -mthumb")
# Set flags for linker
set (CMAKE_EXE_LINKER_FLAGS "-mcpu=cortex-m3 -mthumb -Os -lm -lgcc")

set(CMAKE_C_COMPILER "${ARM_NONE_EABI_TOOLCHAIN}/bin/arm-none-eabi-gcc.exe")
set(CMAKE_ASM_COMPILER ${CMAKE_C_COMPILER})
set(CMAKE_CXX_COMPILER "${ARM_NONE_EABI_TOOLCHAIN}/bin/arm-none-eabi-g++.exe")
set(CMAKE_LINKER "${CMAKE_C_COMPILER}")

# WORKS! set(CMAKE_CXX_LINK_EXECUTABLE "<CMAKE_LINKER> -mcpu=cortex-m3 -mthumb -Os -Wl,--gc-sections -TC://Users//chris//Documents//ArduinoData//packages//arduino//hardware//sam//1.6.12//variants//arduino_due_x/linker_scripts/gcc/flash.ld -Wl,-Map,<TARGET>.map -o <TARGET>.elf -LC://Users//chris//AppData//Local//Temp//arduino_build_875445 -Wl,--cref -Wl,--check-sections -Wl,--gc-sections -Wl,--entry=Reset_Handler -Wl,--unresolved-symbols=report-all -Wl,--warn-common -Wl,--warn-section-align -Wl,--start-group -u _sbrk -u link -u _close -u _fstat -u _isatty -u _lseek -u _read -u _write -u _exit -u kill -u _getpid <OBJECTS> C://Users//chris//AppData//Local//Temp//arduino_build_875445//core//variant.cpp.o C://Users//chris//Documents//ArduinoData//packages//arduino//hardware//sam//1.6.12//variants//arduino_due_x/libsam_sam3x8e_gcc_rel.a C://Users//chris//AppData//Local//Temp//arduino_build_875445/core//core.a -Wl,--end-group -lm -lgcc")

#set(ARDUINO_CORE "${CMAKE_CURRENT_LIST_DIR}/../cores/build/core.a")
#set(VARIANT "${CMAKE_CURRENT_LIST_DIR}/../cores/build/variant.cpp.o")
#set(sam_sam3x8e_gcc_rel "${CMAKE_CURRENT_LIST_DIR}/../variants/arduino_due_x/libsam_sam3x8e_gcc_rel.a")

#set(CMAKE_CXX_LINK_EXECUTABLE "<CMAKE_LINKER> -mcpu=cortex-m3 -mthumb -Os -Wl,--gc-sections -TC://Users//chris//Documents//ArduinoData//packages//arduino//hardware//sam//1.6.12//variants//arduino_due_x/linker_scripts/gcc/flash.ld -Wl,-Map,<TARGET>.map -o <TARGET>.elf -Wl,--cref -Wl,--check-sections -Wl,--gc-sections -Wl,--entry=Reset_Handler -Wl,--unresolved-symbols=report-all -Wl,--warn-common -Wl,--warn-section-align -Wl,--start-group -u _sbrk -u link -u _close -u _fstat -u _isatty -u _lseek -u _read -u _write -u _exit -u kill -u _getpid <OBJECTS> ${VARIANT} ${sam_sam3x8e_gcc_rel} ${ARDUINO_CORE} <LINK_LIBRARIES> -Wl,--end-group -lm -lgcc")
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

