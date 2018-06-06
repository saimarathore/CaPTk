#MESSAGE( "External project - OpenCV" )

SET( OpenCV_DEPENDENCIES )

ExternalProject_Add( 
  OpenCV
  DEPENDS Eigen VTK
  URL https://github.com/opencv/opencv/archive/3.4.1.zip
  #GIT_REPOSITORY ${git_protocol}://github.com/opencv/opencv.git
  #GIT_TAG 3.4.1
  SOURCE_DIR OpenCV-source
  BINARY_DIR OpenCV-build
  UPDATE_COMMAND ""
  PATCH_COMMAND ""
  #INSTALL_COMMAND ""
  CMAKE_GENERATOR ${gen}
  CMAKE_ARGS
    ${ep_common_args}
    #-DCMAKE_CONFIGURATION_TYPES=${CMAKE_CONFIGURATION_TYPES}
    -DENABLE_CXX11:BOOL=ON 
    -DBUILD_EXAMPLES:BOOL=OFF # examples are not needed
    -DBUILD_opencv_apps:BOOL=OFF 
    -DBUILD_SHARED_LIBS:BOOL=OFF # no static builds
    -DBUILD_WITH_STATIC_CRT:BOOL=OFF
    -DBUILD_TESTS:BOOL=OFF 
    -DBUILD_PERF_TESTS:BOOL=OFF 
    -DBUILD_opencv_python2:BOOL=OFF
    -DWITH_CUDA:BOOL=OFF
    -DBUILD_DOCS:BOOL=OFF
    #-DWITH_QT:BOOL=TRUE # [QT] dependency, enables better GUI
    -DWITH_EIGEN:BOOL=TRUE # [QT] dependency, enables better GUI
    -DWITH_OPENMP:BOOL=ON
    -DWITH_OPENGL:BOOL=ON
    -DWITH_VTK:BOOL=ON
    -DBUILD_JAVA:BOOL=OFF 
    -DEIGEN_INCLUDE_PATH:STRING=${EIGEN_INCLUDE_DIR}
    -DVTK_DIR:STRING=${VTK_DIR}
    #-DOpenCV_USE_GUISUPPORT:BOOL=TRUE 
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_BINARY_DIR}/install
)

SET( OpenCV_DIR ${CMAKE_BINARY_DIR}/OpenCV-build )