
find_package(PkgConfig QUIET)
PKG_CHECK_MODULES(JSON QUIET libjansson)

set(DEPENDENT_ROOT_PATHS "$ENV{DEPEND_PATH}")

find_path(JSON_INCLUDE_DIR 
    NAMES 
        jansson.h
    HINTS
        $ENV{DEPEND_PATH}/include
        ${DEPENDENT_ROOT_PATHS}/include
    )

MESSAGE(STATUS "Found header: ${JSON_INCLUDE_DIR}")

find_library(JSON_LIB 
    NAMES 
        jansson
    HINTS
        $ENV{DEPEND_PATH}/lib
        ${DEPENDENT_ROOT_PATHS}/lib
   )

MESSAGE(STATUS "Found library: ${JSON_LIB}")

# handle the QUIETLY and REQUIRED arguments and set JSON_FOUND to TRUE if
# all listed variables are TRUE
include(${CMAKE_CURRENT_LIST_DIR}/FindPackageHandleStandardArgs.cmake)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(JSON DEFAULT_MSG JSON_LIB JSON_INCLUDE_DIR)
mark_as_advanced(JSON_INCLUDE_DIR JSON_LIB)

if(JSON_FOUND)
	set(JSON_INCLUDE_DIRS ${JSON_INCLUDE_DIR})
	set(JSON_LIBRARIES ${JSON_LIB})
endif()