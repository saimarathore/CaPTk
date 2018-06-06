## The Superbuild script is used to automatically download and build project dependencies. 

# Using GIT to download third party libraries. An SVN/BitBucket URL will also work the same way
FIND_PACKAGE( Git REQUIRED )

OPTION( USE_GIT_PROTOCOL "If behind a firewall turn this off to use https instead." OFF )

FIND_PACKAGE(Qt5 COMPONENTS Core Gui Svg Widgets WebView WebEngine WebEngineCore REQUIRED)
LINK_DIRECTORIES(${QT_LIBRARY_DIR})

SET(git_protocol "git")
IF(NOT USE_GIT_PROTOCOL)
	SET(git_protocol "https")
ENDIF()

SET( 
  CMAKE_MODULE_PATH
  ${CMAKE_CURRENT_SOURCE_DIR}/cmake_modules
  ${CMAKE_MODULE_PATH}
)

IF(MSVC)
  SET( CMAKE_BUILD_TYPE "Debug;Release")
ELSEIF(UNIX)
  SET( CMAKE_BUILD_TYPE "Release")
ENDIF()

INCLUDE( ExternalProject )

## Compute -G arg for configuring external projects with the same CMake generator:
#IF(CMAKE_EXTRA_GENERATOR)
#	SET(gen "${CMAKE_EXTRA_GENERATOR} - ${CMAKE_GENERATOR}")
#ELSE()
#	SET(gen "${CMAKE_GENERATOR}" )
#ENDIF()

IF( WIN32 )
  MESSAGE( STATUS "Adding DCMTK-3.6.3 ...")
  INCLUDE( ${CMAKE_CURRENT_SOURCE_DIR}/cmake_modules/External-DCMTK.cmake )
ENDIF()

MESSAGE( STATUS "Adding EIGEN-3.3.4 ...")
INCLUDE( ${CMAKE_CURRENT_SOURCE_DIR}/cmake_modules/External-Eigen.cmake )

MESSAGE( STATUS "Adding VTK-8.1.0 ...")
INCLUDE( ${CMAKE_CURRENT_SOURCE_DIR}/cmake_modules/External-VTK.cmake )

MESSAGE( STATUS "Adding OpenCV-3.4.1 ...")
INCLUDE( ${CMAKE_CURRENT_SOURCE_DIR}/cmake_modules/External-OpenCV.cmake )

MESSAGE( STATUS "Adding ITK-4.13.0 ...")
INCLUDE( ${CMAKE_CURRENT_SOURCE_DIR}/cmake_modules/External-ITK.cmake )

SET( NewCore_DEPENDENCIES )

# Automatic VTK build and link
#OPTION( USE_VTK "Build VTK v5.10.1" OFF )
#IF( ${USE_VTK} )
#	FIND_PACKAGE( VTK REQUIRED )
#	IF( NOT VTK_DIR )
#		MESSAGE( STATUS "VTK not found on system. Adding from source..." )
#		INCLUDE( ${CMAKE_CURRENT_SOURCE_DIR}/cmake_modules/External-VTK.cmake )
#	ENDIF(  )
#	SET( NewCore_DEPENDENCIES ${NewCore_DEPENDENCIES} VTK )
#ENDIF()
