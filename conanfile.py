from conans import ConanFile, CMake, tools
import shutil
import os

def copytree(src, dst, symlinks=False, ignore=None):
    for item in os.listdir(src):
        s = os.path.join(src, item)
        d = os.path.join(dst, item)
        if os.path.isdir(s):
            if (os.path.exists(d)):
                copytree(s, d, symlinks, ignore)
            else:
                shutil.copytree(s, d, symlinks, ignore)
        else:
            shutil.copy2(s, d)


class ArduinoDueCoreConan(ConanFile):
    name = "conan-arduino-due-core"
    version = "1.6.23"
    license = "MIT"
    author = "Christoffer Zakrisson (christoffer_zakrisson@hotmail.com)"
    url = "https://github.com/Zaeb0s/conan-arduino-due-core"
    description = "ArduinoCore-sam packaged for conan for Arduino Due"
    topics = ("arduino", "due", "arm")
    generators = "cmake"       
    exports_sources = "CMakeLists.txt", "profile/*", "ArduinoCore-sam/*"
    settings = {"os": None, "build_type": None, "compiler": ["gcc"], "arch": ["armv7"]}           

    def source(self):        
        self.run("git clone https://github.com/arduino/ArduinoCore-sam.git")        

    def copy_profile(self):
        src = os.path.join("profile")
        dst = os.path.join(os.path.expanduser('~'), ".conan", "profiles")
        print("Copying Arduino Due profile from {0} to {1}".format(src, dst))
        copytree(src, dst)
        print("Copied Arduino Due profile from {0} to {1}".format(src, dst))

    def build(self):
        self.copy_profile()
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
        self.copy("*/variant.cpp.obj", dst="lib", keep_path=False)
        self.copy("*/flash.ld", dst="lib", keep_path=False)
        self.copy("*", src="profile", dst="profile")

    def package_info(self):
        self.cpp_info.libs = ["ArduinoDueCore", "sam_sam3x8e_gcc_rel"]
        self.cpp_info.exelinkflags.append("\"-T{0}/lib/flash.ld\"".format(self.package_folder))
        self.cpp_info.exelinkflags.append("--entry=Reset_Handler")
        self.cpp_info.exelinkflags.append("\"{0}/lib/variant.cpp.obj\"".format(self.package_folder))
        self.cpp_info.exelinkflags.append("-u _sbrk -u link -u _close -u _fstat -u _isatty -u _lseek -u _read -u _write -u _exit -u kill -u _getpid")        

    def deploy(self):        
        self.copy_profile()
