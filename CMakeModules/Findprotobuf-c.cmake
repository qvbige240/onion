
find_package(PkgConfig QUIET)
PKG_CHECK_MODULES(PROTOBUFC QUIET libprotobuf-c)

set(DEPENDENT_ROOT_PATHS "$ENV{DEPEND_PROTOBUF_C_PATH}")

find_path(PROTOBUFC_INCLUDE_DIR 
    NAMES 
        protobuf-c/protobuf-c.h
    HINTS
        $ENV{DEPEND_PATH}/include
        ${DEPENDENT_ROOT_PATHS}/include
    )

MESSAGE(STATUS "Found header: ${PROTOBUFC_INCLUDE_DIR}")

find_library(PROTOBUFC_LIB 
    NAMES 
        protobuf-c
    HINTS
        $ENV{DEPEND_PATH}/lib
        ${DEPENDENT_ROOT_PATHS}/lib
   )

MESSAGE(STATUS "Found library: ${PROTOBUFC_LIB}")

# handle the QUIETLY and REQUIRED arguments and set PROTOBUFC_FOUND to TRUE if
# all listed variables are TRUE
include(${CMAKE_CURRENT_LIST_DIR}/FindPackageHandleStandardArgs.cmake)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(PROTOBUFC DEFAULT_MSG PROTOBUFC_LIB PROTOBUFC_INCLUDE_DIR)
mark_as_advanced(PROTOBUFC_INCLUDE_DIR PROTOBUFC_LIB)

if(PROTOBUFC_FOUND)
	set(PROTOBUFC_INCLUDE_DIRS ${PROTOBUFC_INCLUDE_DIR})
	set(PROTOBUFC_LIBRARIES ${PROTOBUFC_LIB})
endif()