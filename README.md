# Arduino due core packaged for conan

The following steps are required to use this library to build .elf files for Arduino Uno:

- Edit CONAN_CMAKE_TOOLCHAIN_FILE within profile/arduino-due to point to profile/due-toolchain-file.cmake 
- Copy or create a link from profile/arduino-due to the ~/.conan/profiles/arduino-due
- Use the profile setup above when building executables/libraries for Arduino Due.
