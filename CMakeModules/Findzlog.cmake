
find_package(PkgConfig QUIET)
PKG_CHECK_MODULES(ZLOG QUIET libzlog)
# set(LIBXML2_DEFINITIONS ${PC_LIBXML_CFLAGS_OTHER})

set(DEPENDENT_ROOT_PATHS "$ENV{DEPEND_PATH}")

find_path(ZLOG_INCLUDE_DIR 
    NAMES 
        zlog.h
    HINTS
        $ENV{DEPEND_PATH}/include
        ${DEPENDENT_ROOT_PATHS}/include
    )

MESSAGE(STATUS "Found header: ${ZLOG_INCLUDE_DIR}")

find_library(ZLOG_LIB 
    NAMES 
        zlog
    HINTS
        $ENV{DEPEND_PATH}/lib
        ${DEPENDENT_ROOT_PATHS}/lib
   )

MESSAGE(STATUS "Found library: ${ZLOG_LIB}")

# handle the QUIETLY and REQUIRED arguments and set ZLOG_FOUND to TRUE if
# all listed variables are TRUE
include(${CMAKE_CURRENT_LIST_DIR}/FindPackageHandleStandardArgs.cmake)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(ZLOG DEFAULT_MSG ZLOG_LIB ZLOG_INCLUDE_DIR)
mark_as_advanced(ZLOG_INCLUDE_DIR ZLOG_LIB)

if(ZLOG_FOUND)
	set(ZLOG_INCLUDE_DIRS ${ZLOG_INCLUDE_DIR})
	set(ZLOG_LIBRARIES ${ZLOG_LIB})
endif()