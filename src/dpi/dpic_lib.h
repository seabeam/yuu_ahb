//##################################################################################
// Copyright 2018 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
//##################################################################################

#ifndef DPI_C_LIB_H
#define DPI_C_LIB_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

#define VCSMX

#ifndef dpi_time_unit
#define dpi_time_unit "ns"
#endif

#define DPI_VLOG 0
#define DPI_VHDL 1

// Message level
#define dpi_debug     0
#define dpi_info      100
#define dpi_warning   200
#define dpi_error     300
#define dpi_fatal     400

#define dpic_debug(fmt, ...) dpic_log(dpi_debug, dpic_sprintf(fmt, ##__VA_ARGS__), __FILE__, __LINE__);
#define dpic_info(fmt, ...) dpic_log(dpi_info, dpic_sprintf(fmt, ##__VA_ARGS__), __FILE__, __LINE__);
#define dpic_warning(fmt, ...) dpic_log(dpi_warning, dpic_sprintf(fmt, ##__VA_ARGS__), __FILE__, __LINE__);
#define dpic_error(fmt, ...) dpic_log(dpi_error, dpic_sprintf(fmt, ##__VA_ARGS__), __FILE__, __LINE__);
#define dpic_fatal(fmt, ...) dpic_log(dpi_fatal, dpic_sprintf(fmt, ##__VA_ARGS__), __FILE__, __LINE__);

extern void   dpic_set_prefix(const char *s);
extern int    dpic_wait_change(const char *path);
extern int    dpic_wait_change_value(const char *path, const int expected_value);
extern int    dpic_get(const char *path, int *data);
extern void   dpisv_wait_time(const int unsigned n, const char *unit);
extern void   dpic_log(int severity, char *msg, char *file, unsigned line);
extern char*  dpic_sprintf(const char *fmt, ...); 
extern void   dpic_set_severity(const int unsigned severity);
extern double dpic_get_real_time();
extern char*  dpic_get_time_unit();

#endif
