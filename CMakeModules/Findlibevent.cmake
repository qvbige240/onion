# - Find libevent
# Find the native libevent includes and library.
# Once done this will define
#
#  LIBEVENT_INCLUDE_DIRS - where to find event2/event.h, etc.
#  LIBEVENT_LIBRARIES    - List of libraries when using libevent.
#  LIBEVENT_FOUND        - True if libevent found.
#
#  LIBEVENT_VERSION_STRING - The version of libevent found (x.y.z)
#  LIBEVENT_VERSION_MAJOR  - The major version
#  LIBEVENT_VERSION_MINOR  - The minor version
#  LIBEVENT_VERSION_PATCH  - The patch version
#
# Avaliable components:
#  core
#  pthreads
#  extra
#  openssl
#

find_package(PkgConfig QUIET)
PKG_CHECK_MODULES(LIBEVENT QUIET libevent)
# find_package(PkgConfig)
# PKG_CHECK_MODULES(LIBEVENT libevent)

set(DEPENDENT_ROOT_PATHS "$ENV{DEPEND_PATH}")
# set(DEPENDENT_ROOT_PATHS "/home/zouqing/work/carnet/linux/auto/vmp/premake/ubuntu/install")

set(_LIBEVENT_ROOT_HINTS_AND_PATHS
    HINTS ${DEPENDENT_ROOT_PATHS}
    PATHS ${DEPENDENT_ROOT_PATHS})

SET(LIBEVENT_core_LIBRARY "NOTREQ")
SET(LIBEVENT_pthreads_LIBRARY "NOTREQ")
SET(LIBEVENT_extra_LIBRARY "NOTREQ")
SET(LIBEVENT_openssl_LIBRARY "NOTREQ")

MESSAGE(STATUS "1Found header: ${DEPENDENT_ROOT_PATHS}")

find_path(_LIBEVENT_INCLUDE_DIR 
    NAMES 
        event.h
    HINTS
        $ENV{DEPEND_PATH}/include
        ${DEPENDENT_ROOT_PATHS}/include
    )

# IF(_LIBEVENT_INCLUDE_DIR AND EXISTS "${_LIBEVENT_INCLUDE_DIR}/event2/event-config.h")
IF(_LIBEVENT_INCLUDE_DIR)
    # Read and parse libevent version header file for version number
    # file(STRINGS "${_LIBEVENT_INCLUDE_DIR}/event2/event-config.h" _libevent_HEADER_CONTENTS)
    file(READ "${_LIBEVENT_INCLUDE_DIR}/event2/event-config.h" _libevent_HEADER_CONTENTS)
    # file(READ "/home/zouqing/work/carnet/linux/auto/vmp/premake/ubuntu/install/include/event2/event-config.h" _libevent_HEADER_CONTENTS)
    MESSAGE(STATUS "Found header: ${_LIBEVENT_INCLUDE_DIR}")

    #string(REGEX REPLACE ".*#define EVENT__VERSION +\"([0-9]+).*" "\\1" LIBEVENT_VERSION_MAJOR "${_libevent_HEADER_CONTENTS}")
    #string(REGEX REPLACE ".*#define EVENT__VERSION +\"[0-9]+\\.([0-9]+).*" "\\1" LIBEVENT_VERSION_MINOR "${_libevent_HEADER_CONTENTS}")
    #string(REGEX REPLACE ".*#define EVENT__VERSION +\"[0-9]+\\.[0-9]+\\.([0-9]+).*" "\\1" LIBEVENT_VERSION_PATCH "${_libevent_HEADER_CONTENTS}")

    #SET(LIBEVENT_VERSION_STRING "${LIBEVENT_VERSION_MAJOR}.${LIBEVENT_VERSION_MINOR}.${LIBEVENT_VERSION_PATCH}") 
    string(REGEX REPLACE ".*#define EVENT__VERSION +\"([0-9].*)\".*" "\\1" LIBEVENT_VERSION "${_libevent_HEADER_CONTENTS}")
    if (NOT LIBEVENT_VERSION)
        string(REGEX REPLACE ".*#define _EVENT_VERSION +\"([0-9].*)\".*" "\\1" LIBEVENT_VERSION "${_libevent_HEADER_CONTENTS}")
    endif ()
    SET(LIBEVENT_VERSION_STRING "${LIBEVENT_VERSION}")

    MESSAGE(STATUS "Found version: ${LIBEVENT_VERSION_STRING}")
ENDIF()

FOREACH(component ${libevent_FIND_COMPONENTS})
    UNSET(LIBEVENT_${component}_LIBRARY)
    FIND_LIBRARY(LIBEVENT_${component}_LIBRARY NAMES event_${component} 
        HINTS 
            $ENV{DEPEND_PATH}/lib
            ${DEPENDENT_ROOT_PATHS}/lib
        )
    #MESSAGE(STATUS "Found library: ${LIBEVENT_${component}_LIBRARY}")
ENDFOREACH()

# handle the QUIETLY and REQUIRED arguments and set LIBEVENT_FOUND to TRUE if
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(libevent
        REQUIRED_VARS LIBEVENT_core_LIBRARY LIBEVENT_pthreads_LIBRARY LIBEVENT_extra_LIBRARY LIBEVENT_openssl_LIBRARY _LIBEVENT_INCLUDE_DIR
        VERSION_VAR LIBEVENT_VERSION_STRING
        )

IF(LIBEVENT_FOUND)
    SET(LIBEVENT_INCLUDE_DIRS ${_LIBEVENT_INCLUDE_DIR})
    FOREACH(component ${libevent_FIND_COMPONENTS})
        LIST(APPEND LIBEVENT_LIBRARIES ${LIBEVENT_${component}_LIBRARY})
    ENDFOREACH()
ENDIF()

MARK_AS_ADVANCED(LIBEVENT_core_LIBRARY LIBEVENT_pthreads_LIBRARY LIBEVENT_extra_LIBRARY LIBEVENT_openssl_LIBRARY _LIBEVENT_INCLUDE_DIR)
