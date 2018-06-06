#MESSAGE( "External project - YAMLCPP" )

set(proj YAMLCPP)

set(${proj}_DEPENDENCIES "")

ExternalProject_Add( 
  YAMLCPP
  URL https://github.com/jbeder/yaml-cpp/archive/yaml-cpp-0.6.2.zip
  SOURCE_DIR YAMLCPP-source
  BINARY_DIR YAMLCPP-build
  UPDATE_COMMAND ""
  PATCH_COMMAND ""
  #INSTALL_COMMAND ""
  CMAKE_GENERATOR ${gen}
  CMAKE_ARGS
    ${ep_common_args}
    -DCMAKE_CONFIGURATION_TYPES="Debug;Release"
    -DCMAKE_INSTALL_PREFIX:STRING=${CMAKE_BINARY_DIR}/install
    -DBUILD_TESTING:BOOL=OFF
    -DBUILD_SHARED_LIBS:BOOL=OFF
)

SET( YAMLCPP_DIR ${CMAKE_BINARY_DIR}/YAMLCPP-build )