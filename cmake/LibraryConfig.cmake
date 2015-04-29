include(CompareVersionStrings)
include(DependencyUtilities)
include(FindPackageHandleStandardArgs)

# Prevent CMake from finding libraries in the installation folder on Windows.
# There might already be an installation from another compiler
if(DEPENDENCY_PACKAGE_ENABLE)
  list(REMOVE_ITEM CMAKE_SYSTEM_PREFIX_PATH  "${CMAKE_INSTALL_PREFIX}")
  list(REMOVE_ITEM CMAKE_SYSTEM_LIBRARY_PATH "${CMAKE_INSTALL_PREFIX}/bin")
endif()

############### Library finding #################
# Performs the search and sets the variables    #
camodocal_required_dependency(BLAS)
camodocal_optional_dependency(CUDA)
camodocal_required_dependency(Eigen3)
camodocal_required_dependency(LAPACK)
camodocal_required_dependency(OpenCV)
camodocal_required_dependency(SuiteSparse)

camodocal_optional_dependency(GTest)
camodocal_optional_dependency(OpenMP)
camodocal_optional_dependency(Glog)
camodocal_optional_dependency(Gflags)

# Consider making this impossible to use external Ceres again due to the following possible issue:
# https://github.com/ceres-solver/ceres-solver/issues/155
# essentially, invsible ABI changes are possible depending on eigen flags
# and the best way to prevent this is to compile everything internally, including ceres
#camodocal_optional_dependency(Ceres)
camodocal_optional_dependency(Threads)

# enable GPU enhanced SURF features
if(CUDA_FOUND)
    add_definitions(-DHAVE_CUDA)
endif()

# OSX RPATH
if(APPLE)
   set(CMAKE_MACOSX_RPATH ON)
endif()

find_library(GFORTRAN_LIBRARY NAMES gfortran REQUIRED)

##### Boost #####
# Expand the next statement if newer boost versions than 1.40.0 are released
set(Boost_ADDITIONAL_VERSIONS "1.40" "1.40.0" "1.49" "1.49.0" "1.54")

find_package(Boost 1.40 REQUIRED COMPONENTS filesystem program_options serialization system thread)

# MSVC seems to be the only compiler requiring date_time
if(MSVC)
  find_package(Boost 1.40 REQUIRED date_time)
endif(MSVC)

# No auto linking, so this option is useless anyway
mark_as_advanced(Boost_LIB_DIAGNOSTIC_DEFINITIONS)
