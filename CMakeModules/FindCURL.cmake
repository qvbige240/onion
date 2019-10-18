# Once done these will be defined:
#
#  LIBCURL_FOUND
#  LIBCURL_INCLUDE_DIRS
#  LIBCURL_LIBRARIES
#
# For use in OBS:
#
#  CURL_INCLUDE_DIR

find_package(PkgConfig QUIET)
PKG_CHECK_MODULES(_CURL QUIET curl libcurl)
# set(LIBXML2_DEFINITIONS ${PC_LIBXML_CFLAGS_OTHER})

find_path(CURL_INCLUDE_DIR NAMES curl/curl.h
   HINTS
      ${LIBCURL_INCLUDE_DIRS}
      
   PATHS
      $ENV{DEPEND_PATH}/include
   PATH_SUFFIXES curl
   )

find_library(CURL_LIB NAMES curl libcurl
   HINTS
   ${CURL_LIBRARIES}
   PATHS
      /usr/lib /usr/local/lib /opt/local/lib $ENV{DEPEND_PATH}/lib
   )

#find_program(CURL_EXECUTABLE curl)


# handle the QUIETLY and REQUIRED arguments and set LIBCURL_FOUND to TRUE if
# all listed variables are TRUE
include(${CMAKE_CURRENT_LIST_DIR}/FindPackageHandleStandardArgs.cmake)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(CURL DEFAULT_MSG CURL_LIB CURL_INCLUDE_DIR)
mark_as_advanced(CURL_INCLUDE_DIR CURL_LIB)

if(CURL_FOUND)
	set(LIBCURL_INCLUDE_DIRS ${CURL_INCLUDE_DIR})
	set(CURL_LIBRARIES ${CURL_LIB})
endif()