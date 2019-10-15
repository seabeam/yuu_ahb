//##################################################################################
// Copyright 2018 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
//##################################################################################

#include "dpic_lib.h"
#include "dpi/uvm_dpi.cc"

// Time
char *top;

void dpic_set_top(char *path) {
  top = (char *)calloc(strlen(path)+1, sizeof(char));

  strcpy(top, path);
}

double dpic_get_real_time() {
  mhpiTimeT *time = (mhpiTimeT *)calloc(1, sizeof(mhpiTimeT));
  mhpi_get_time(time);

  return time->real;
}

char *dpic_get_time_unit() {
  int   tu_int;
  char *tu_str = (char *)calloc(3, sizeof(char));
  
  if (top == NULL) {
    top = (char *)calloc(4, sizeof(char));
    top = "top";
  }

  mhpiHandleT mhpiH = mhpi_handle_by_name(top, 0);
  if (mhpi_get(mhpiPliP, mhpiH) == mhpiVpiPli) {
    tu_int = vpi_get(vpiTimeUnit, vpi_handle_by_name(top, 0));
  }
  else if (mhpi_get(mhpiPliP, mhpiH) == mhpiVhpiPli) {
    tu_int = vhpi_get(vhpiSimTimeUnitP, vhpi_handle_by_name(top, 0));
  } else {
    dpic_fatal("Top %s has unknown type language", top);
    vpi_control(vpiFinish, 0);
    return 0;
  }
  
  switch (tu_int) {
    case -15:
    case -14:
    case -13:
      tu_str = "fs";
      break;
    case -12:
    case -11:
    case -10:
      tu_str = "ps";
      break;
    case -9:
    case -8:
    case -7:
      tu_str = "ns";
      break;
    case -6:
    case -5:
    case -4:
      tu_str = "us";
      break;
    case -3:
    case -2:
    case -1:
      tu_str = "ms";
      break;
    case  0:
    case  1:
    case  2:
      tu_str = "s";
      break;
    default: dpic_warning("Unknown time unit format");
  }
  
  return tu_str;
}

char *dpic_get_time() {
  char *unit = dpic_get_time_unit();
  char *line = (char*)calloc(32, sizeof(char));

  sprintf(line, "%.2f %s", dpic_get_real_time(), unit);

  return line;
}





// Message function
static int dpic_severity = dpi_info;
static char *prefix = (char *)0;

void dpic_set_prefix(const char *s) {
  prefix = (char *)calloc(strlen(s)+1, sizeof(char)); 
  strcpy(prefix, s);
}

char* dpic_sprintf(const char *fmt, ...) {
  int buf_size = 128;
  char *buf = (char *)calloc(buf_size, sizeof(char));
  if (buf == NULL) {
    vpi_printf("WARNING: %s(%d) @ %.f [%s] Allocate heap space failed\n", __FILE__, __LINE__, dpic_get_real_time(), prefix);
    return NULL;
  }
  va_list args;

  int cnt = 0;
  while(1) {
    va_start(args, fmt);
    int len = vsnprintf(buf, buf_size, fmt, args);
    va_end(args);

    if (len > -1 && len < buf_size) {
      return buf;
    } else {
      buf_size += buf_size;
      if ((buf = (char *)realloc(buf, buf_size*sizeof(char))) == NULL) {
        vpi_printf("WARNING: %s(%d) @ %.f [%s] Allocate heap space failed\n", __FILE__, __LINE__, dpic_get_real_time(), prefix);
        return NULL;
      }
    }
    cnt ++;
    if (cnt >= 4) {
      vpi_printf("WARNING: %s(%d) @ %.f [%s] Message length should less then 1024\n", __FILE__, __LINE__, dpic_get_real_time(), prefix);
      return NULL;
    }
  }
}

void dpic_log(int severity, char *msg, char *file, unsigned line) {
  if (severity < dpic_severity) {
    return;
  }

  if (prefix == (char *)0) {
    prefix = (char *)calloc(12, sizeof(char));
    prefix = "DPI C LIB";
  }
  switch(severity) {
    case(dpi_debug):  vpi_printf("DEBUG: %s(%d) @ %.f [%s] %s\n", file, line, dpic_get_real_time(), prefix, msg); break;
    case(dpi_info):   vpi_printf("INFO: %s(%d) @ %.f [%s] %s\n", file, line, dpic_get_real_time(), prefix, msg); break;
    case(dpi_warning):vpi_printf("WARNING: %s(%d) @ %.f [%s] %s\n", file, line, dpic_get_real_time(), prefix, msg); break;
    case(dpi_error):  vpi_printf("ERROR: %s(%d) @ %.f [%s] %s\n", file, line, dpic_get_real_time(), prefix, msg); break;
    case(dpi_fatal):  vpi_printf("FATAL: %s(%d) @ %.f [%s] %s\n", file, line, dpic_get_real_time(), prefix, msg); break;
    default: vpi_printf("WARNING: %s(%d) @ %.f [%s] Invalid message severity\n", file, line, dpic_get_real_time(), prefix); return;
  }
}

void dpic_set_severity(const int unsigned severity) {
  if (severity > 400) {
    dpic_debug("The highest setting of message severity is dpi_fatal, user setting will be ignored.");
    return;
  }
  dpic_severity = severity;
}




// Callback function
int get_it = 0;

typedef struct t_dpic_wait_change_cb_data {
  char  *path;
  int   is_wait_value;
  int   expected_value;
} s_dpic_wait_change_cb_data, *p_dpic_wait_change_cb_data;

vpiHandle vlogCbHandle;
PLI_INT32 dpic_wait_change_vlog_callback(p_cb_data cb_data_p) {
  p_dpic_wait_change_cb_data cb_user_data = (p_dpic_wait_change_cb_data) cb_data_p->user_data;
  int current_value;

  if (!dpic_get(cb_user_data->path, &current_value)){
    return 0;
  }

  if ((cb_user_data->is_wait_value == 1) && (current_value != cb_user_data->expected_value)) {
    return 1;
  } else {
    dpic_info("Value of vlog signal %s is changed to 0x%X",
                cb_user_data->path,
                current_value);
    vpi_remove_cb(vlogCbHandle);
    get_it = 1;
  
    return 1;
  }
}

vhpiHandleT vhdlCbHandle;
void dpic_wait_change_vhdl_callback(vhpiCbDataT* cb_data_p) {
  p_dpic_wait_change_cb_data cb_user_data = (p_dpic_wait_change_cb_data) cb_data_p->user_data;
  int current_value;

  if (!dpic_get(cb_user_data->path, &current_value)){
    return;
  }

  if ((cb_user_data->is_wait_value == 1) && (current_value != cb_user_data->expected_value)) {
    return;
  } else {
    dpic_info("Value of vhdl signal %s is changed to 0x%X",
                cb_user_data->path,
                current_value);
    vhpi_remove_cb(vhdlCbHandle);
    get_it = 1;

    return;
  }
}
// Callback function end



int dpic_wait_change_vlog_common(const char *path, const int is_wait_value, const int expected_value) {
  vpiHandle   net;
  
  mhpiHandleT h = mhpi_handle_by_name(path, 0);
  net = (vpiHandle) mhpi_get_vpi_handle(h);

  if (net == 0) {
    dpic_error("Can't locate vlog signal %s", path);
    return 0;
  }

  s_vpi_time  time_s;
  time_s.type     = vpiScaledRealTime;

  s_vpi_value value_s;
  value_s.format  = vpiBinStrVal;

  s_cb_data   cb_data_s;

  cb_data_s.reason    = cbValueChange;
  cb_data_s.cb_rtn    = dpic_wait_change_vlog_callback;
  cb_data_s.time      = &time_s;
  cb_data_s.value     = &value_s;
  cb_data_s.obj       = net;
  
  s_dpic_wait_change_cb_data cb_user_data_s;
  char *path_keep;
  path_keep = malloc(strlen(path)+1);
  strcpy(path_keep, path);
  cb_user_data_s.path = path_keep;
  cb_user_data_s.is_wait_value = is_wait_value;
  cb_user_data_s.expected_value = expected_value;
  cb_data_s.user_data = (PLI_BYTE8 *)(&cb_user_data_s);
  vlogCbHandle = vpi_register_cb(&cb_data_s);

  mhpi_release_parent_handle(h);
  return 1;
}

int dpic_wait_change_vlog(const char *path) {
  return (dpic_wait_change_vlog_common(path, 0, 0));
}

int dpic_wait_change_value_vlog(const char *path, const int expected_value) {
  return (dpic_wait_change_vlog_common(path, 1, expected_value));
}




int dpic_wait_change_vhdl_common(const char *path, const int is_wait_value, const int expected_value) {
  vhpiHandleT  net;
  
  mhpiHandleT h = mhpi_handle_by_name(path, 0);
  net = (long unsigned int *)mhpi_get_vhpi_handle(h);
  if (net == 0) {
    dpic_error("Can't locate vhdl signal %s", path);
    return 0;
  }

  vhpiTimeT  time_s;

  vhpiValueT value_s;
  value_s.format  = vhpiIntVecVal;

  vhpiCbDataT   cb_data_s;

  cb_data_s.reason  = vhpiCbValueChange;
  cb_data_s.cbf     = dpic_wait_change_vhdl_callback;
  cb_data_s.time    = &time_s;
  cb_data_s.value   = &value_s;
  cb_data_s.obj     = net;

  s_dpic_wait_change_cb_data cb_user_data_s;
  char *path_keep;
  path_keep = malloc(strlen(path)+1);
  strcpy(path_keep, path);
  cb_user_data_s.path = path_keep;
  cb_user_data_s.is_wait_value = is_wait_value;
  cb_user_data_s.expected_value = expected_value;

  cb_data_s.user_data = (void *)(&cb_user_data_s);
  vhdlCbHandle = vhpi_register_cb(&cb_data_s, 0);

  mhpi_release_parent_handle(h);
  return 1;
}




int dpic_wait_change_common(const char *path, const int is_wait_value, const int expected_value) {
  int language;

  mhpi_initialize('/');
  mhpiHandleT mhpiH = mhpi_handle_by_name(path, 0);

  if (mhpi_get(mhpiPliP, mhpiH) == mhpiVpiPli) {
    language = DPI_VLOG;
    if (is_wait_value) {
      dpic_wait_change_vlog_common(path, 1, expected_value);
    } else {
      dpic_wait_change_vlog_common(path, 0, 0);
    }
  }
  else if (mhpi_get(mhpiPliP, mhpiH) == mhpiVhpiPli) {
    language = DPI_VHDL;
    if (is_wait_value) {
      dpic_wait_change_vhdl_common(path, 1, expected_value);
    } else {
      dpic_wait_change_vhdl_common(path, 0, 0);
    }
  } else {
    s_vpi_time current_time;
    current_time.type = vpiScaledRealTime;

    vpiHandle r = (vpiHandle)mhpi_get_vpi_handle(mhpiH);
    vpi_get_time(r, &current_time);

    dpic_fatal("Signal %s has unknown type language", path);
    vpi_control(vpiFinish, 0);
    return 0;
  }

  vpiHandle   vlogH;
  vhpiHandleT vhdlH;
  if (language == DPI_VLOG) {
    s_vpi_time current_time;
    current_time.type = vpiScaledRealTime;

    vlogH = (vpiHandle)mhpi_get_vpi_handle(mhpiH);
    vpi_get_time(vlogH, &current_time);

    dpic_info("Start to wait vlog signal %s", current_time.real, path);
  } else {
    vhpiTimeT current_time;

    vhdlH = (long unsigned int *)mhpi_get_vhpi_handle(mhpiH);
    vhpi_get_time(&current_time, 0);

    dpic_info("Start to wait vhdl signal %s", path);
  }

  while(get_it == 0)
    dpisv_wait_time(1, dpi_time_unit);

  if (language == DPI_VLOG) {
    dpic_info("Finish waiting vlog signal %s", path);
    vpi_free_object(vlogH);
  } else { 
    vhpiTimeT current_time;

    vhdlH = (long unsigned int *)mhpi_get_vhpi_handle(mhpiH);
    vhpi_get_time(&current_time, 0);

    dpic_info("Finish waiting vhdl signal %s", path);
    vhpi_release_handle(vhdlH);
  }
  mhpi_release_parent_handle(mhpiH);
  return 1;
}

int dpic_wait_change(const char *path) {
  return (dpic_wait_change_common(path, 0, 0));
}

int dpic_wait_change_value(const char *path, const int expected_value) {
  return (dpic_wait_change_common(path, 1, expected_value));
}

int dpic_get(const char *path, int *data) {
  s_vpi_vecval value;

  uvm_hdl_read(path, &value);

  if(value.bval != 0) {
    dpic_warning("Signal %s is unknown", path);

    *data = -1;
    return 0;
  } else {
    *data = value.aval;
    return 1;
  }
}

