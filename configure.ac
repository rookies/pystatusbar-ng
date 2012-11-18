#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ(2.69)
AC_INIT(pystatusbar-ng, 0.1, https://github.com/rookies/pystatusbar-ng)
AC_CONFIG_SRCDIR(src/main.cpp)
AC_CONFIG_SRCDIR(src/statusbar.cpp)
AC_CONFIG_SRCDIR(src/config.cpp)
AC_CONFIG_SRCDIR(src/plugin.cpp)
#AC_CONFIG_HEADERS([config.h])

# Checks for programs.
AC_PROG_CXX

# Checks for libraries.
AC_CHECK_LIB(lua, luaL_newstate)
AC_CHECK_LIB(pthread, pthread_create)

# Checks for header files.
AC_CHECK_HEADERS(iostream)
AC_CHECK_HEADERS(pthread.h)
AC_CHECK_HEADERS(assert.h)
AC_CHECK_HEADERS(glob.h)
AC_CHECK_HEADERS(libgen.h)
AC_CHECK_HEADERS(unistd.h)
AC_CHECK_HEADERS(lua.h)
AC_CHECK_HEADERS(lualib.h)
AC_CHECK_HEADERS(lauxlib.h)
AC_CHECK_HEADERS(sstream)
AC_CHECK_HEADERS(time.h)

# Checks for typedefs, structures, and compiler characteristics.
AC_CHECK_HEADER_STDBOOL

# Checks for library functions.

AC_OUTPUT
