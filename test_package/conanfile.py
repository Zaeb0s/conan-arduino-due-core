import os

from conans import ConanFile, CMake, tools


class BlinkConan(ConanFile):
    settings = "os", "compiler", "build_type", "arch"
    generators = "cmake"

    def build(self):
        cmake = CMake(self)
        cmake.verbose = True
        cmake.configure()
        cmake.build()
        
    def imports(self):        
        self.copy('*.a', dst='bin', src='lib')

    def test(self):
        # Do nothing just make sure it compiles ok
        pass
