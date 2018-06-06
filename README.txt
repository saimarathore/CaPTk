This is a CMake-based project that builds the dependencies of CaPTk, specifically DCMTK, Eigen, VTK, OpenCV and ITK. 

Pre-requisites: Qt (tested on 5.10.1) and Git (2.6+) and both binaries should be present in the ${PATH}

Set the variable "CMAKE_INSTALL_PREFIX" to where you want all the libraries to be installed

Windows Users: Please build this package with a short path (like C:/CaPTk_depends) so that the string overflow in path is avoided.

Linux Users: Ensure you use the command "make install/strip"

Add the following paths to the environment variable ${CMAKE_PREFIX_PATH} (preferred; or they can be added to ${PATH} instead) for CMake to find it automatically:

- ${CMAKE_INSTALL_PREFIX}/lib/cmake/ITK-${ver} # for ITK to be detected automatically
- ${CMAKE_INSTALL_PREFIX}/lib/cmake/VTK-${ver} # for VTK to be detected automatically
- ${CMAKE_INSTALL_PREFIX} # for OpenCV to be detected automatically
- ${CMAKE_INSTALL_PREFIX}/cmake # for DCMTK to be detected automatically