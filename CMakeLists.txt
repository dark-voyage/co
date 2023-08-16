# Minimum version of CMake to build
cmake_minimum_required(VERSION 3.26)

# Project configurations
project(experiment VERSION 1.0)

# Set C standard
set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_OBJC_STANDARD 17)
set(CMAKE_OBJC_STANDARD_REQUIRED ON)

# Specify the CMAKE_OSX_SYSROOT to indicate which SDK should be used
set(CMAKE_OSX_SYSROOT "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk")

# Define a variable for the Objective-C compiler flags
set(CMAKE_OBJC_FLAGS "-x objective-c -fobjc-arc")

# Define a variable for the frameworks to be linked with
set(OBJC_FRAMEWORKS "-framework Foundation")

# Set C flags
include_directories(.)

# Add subdirectories
include_directories(experiment)

# Add executables
add_executable(experiment
        experiment/main.m
        experiment/telegram.m
        experiment/telegram.h)
target_link_libraries(experiment "-framework Foundation")

# Set the properties for the target
set_target_properties(experiment PROPERTIES
        COMPILE_FLAGS "${CMAKE_OBJC_FLAGS}"
        LINK_FLAGS "${OBJC_FRAMEWORKS}"
)

# Add a custom target to run the executable
add_custom_target(run
        COMMAND experiment
        DEPENDS experiment
        USES_TERMINAL
)