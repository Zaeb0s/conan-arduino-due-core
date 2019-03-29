from conans import ConanFile, CMake


class ArduinoDueCoreConan(ConanFile):
    name = "conan-arduino-due-core"
    version = "1.6.23"
    license = "MIT"
    author = "Christoffer Zakrisson (christoffer_zakrisson@hotmail.com)"
    url = "https://github.com/Zaeb0s/conan-arduino-due-core"
    description = "ArduinoCore-sam packaged for conan for Arduino Due"
    topics = ("arduino", "due", "arm")
    generators = "cmake"       
    exports_sources = "CMakeLists.txt"
    settings = {"os": None, "build_type": None, "compiler": ["gcc"], "arch": ["armv7"]}           
    
    def source(self):
        self.run("git clone https://github.com/arduino/ArduinoCore-sam.git")        
    
    def build(self):        
        cmake = CMake(self)
        cmake.configure()
        cmake.build()
        
    def package(self):
        self.copy("*.h", src="ArduinoCore-sam/system/libsam", dst="include")
        self.copy("*.h", src="ArduinoCore-sam/system/CMSIS/CMSIS/Include", dst="include")
        self.copy("*.h", src="ArduinoCore-sam/system/CMSIS/Device/ATMEL", dst="include")
        self.copy("*.h", src="ArduinoCore-sam/cores/arduino", dst="include")
        self.copy("*.h", src="ArduinoCore-sam/variants/arduino_due_x", dst="include")    
        self.copy("*/libArduinoDueCore.a", dst="lib", keep_path=False)
        self.copy("*/libsam_sam3x8e_gcc_rel.a", dst="lib", keep_path=False)
        self.copy("*/libvariant.a", dst="lib", keep_path=False)
        self.copy("*/flash.ld", dst="lib", keep_path=False)

    def package_info(self):
        self.cpp_info.libs = ["ArduinoDueCore", "sam_sam3x8e_gcc_rel", "variant"]
        self.cpp_info.exelinkflags.append("--entry=Reset_Handler")
        self.cpp_info.exelinkflags.append("-Wl,--cref -Wl,--check-sections -Wl,--gc-sections -Wl,--entry=Reset_Handler -Wl,--warn-common -Wl,--warn-section-align -Wl,--start-group -u _sbrk -u link -u _close -u _fstat -u _isatty -u _lseek -u _read -u _write -u _exit -u kill -u _getpid")
        self.cpp_info.exelinkflags.append("-Wl,--gc-sections -Tflash.ld")

