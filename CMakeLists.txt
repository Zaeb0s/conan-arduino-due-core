cmake_minimum_required(VERSION 2.8.12)

project(ArduinoDueCore C CXX ASM)

file(GLOB SRC "ArduinoCore-sam/cores/arduino/*.h" "ArduinoCore-sam/cores/arduino/*.cpp" "ArduinoCore-sam/cores/arduino/*.c")

include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup()


add_library(${CMAKE_PROJECT_NAME} STATIC
    "ArduinoCore-sam/cores/arduino/wiring_pulse_asm.S"
    "ArduinoCore-sam/cores/arduino/WInterrupts.c"
    "ArduinoCore-sam/cores/arduino/syscalls_sam3.c"
    "ArduinoCore-sam/cores/arduino/wiring_digital.c"
    "ArduinoCore-sam/cores/arduino/wiring_shift.c"
    "ArduinoCore-sam/cores/arduino/wiring.c"
    "ArduinoCore-sam/cores/arduino/cortex_handlers.c"
    "ArduinoCore-sam/cores/arduino/itoa.c"
    "ArduinoCore-sam/cores/arduino/hooks.c"
    "ArduinoCore-sam/cores/arduino/avr/dtostrf.c"
    "ArduinoCore-sam/cores/arduino/iar_calls_sam3.c"
    "ArduinoCore-sam/cores/arduino/wiring_analog.c"
    "ArduinoCore-sam/cores/arduino/Stream.cpp"
    "ArduinoCore-sam/cores/arduino/IPAddress.cpp"
    "ArduinoCore-sam/cores/arduino/Reset.cpp" 
    "ArduinoCore-sam/cores/arduino/RingBuffer.cpp"
    "ArduinoCore-sam/cores/arduino/WMath.cpp"
    "ArduinoCore-sam/cores/arduino/USARTClass.cpp"
    "ArduinoCore-sam/cores/arduino/wiring_pulse.cpp"
    "ArduinoCore-sam/cores/arduino/USB/PluggableUSB.cpp"
    "ArduinoCore-sam/cores/arduino/Print.cpp"
    "ArduinoCore-sam/cores/arduino/abi.cpp"
    "ArduinoCore-sam/cores/arduino/new.cpp"
    "ArduinoCore-sam/cores/arduino/USB/CDC.cpp"
    "ArduinoCore-sam/cores/arduino/watchdog.cpp"
    "ArduinoCore-sam/cores/arduino/USB/USBCore.cpp"
    "ArduinoCore-sam/cores/arduino/main.cpp"
    "ArduinoCore-sam/cores/arduino/WString.cpp"
    "ArduinoCore-sam/cores/arduino/UARTClass.cpp"
)
SET_TARGET_PROPERTIES(${CMAKE_PROJECT_NAME}  
   PROPERTIES LINKER_LANGUAGE ASM) 
add_library(variant "ArduinoCore-sam/variants/arduino_due_x/variant.cpp")


target_link_libraries(${CMAKE_PROJECT_NAME} ${CONAN_LIBS})
target_link_libraries(variant ${CONAN_LIBS})

target_link_libraries(${CMAKE_PROJECT_NAME} variant)
target_link_libraries(variant ${CMAKE_PROJECT_NAME})

target_include_directories(${CMAKE_PROJECT_NAME} PUBLIC "ArduinoCore-sam/system/libsam")
target_include_directories(${CMAKE_PROJECT_NAME} PUBLIC "ArduinoCore-sam/system/CMSIS/CMSIS/Include")
target_include_directories(${CMAKE_PROJECT_NAME} PUBLIC "ArduinoCore-sam/system/CMSIS/Device/ATMEL")
target_include_directories(${CMAKE_PROJECT_NAME} PUBLIC "ArduinoCore-sam/cores/arduino")
target_include_directories(${CMAKE_PROJECT_NAME} PUBLIC "ArduinoCore-sam/variants/arduino_due_x")

target_include_directories(variant PUBLIC "ArduinoCore-sam/system/libsam")
target_include_directories(variant PUBLIC "ArduinoCore-sam/system/CMSIS/CMSIS/Include")
target_include_directories(variant PUBLIC "ArduinoCore-sam/system/CMSIS/Device/ATMEL")
target_include_directories(variant PUBLIC "ArduinoCore-sam/cores/arduino")
target_include_directories(variant PUBLIC "ArduinoCore-sam/variants/arduino_due_x")

