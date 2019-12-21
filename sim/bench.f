// +--------------+
// | MACRO DEFINE |
// +--------------+
-timescale=1ns/1ps

// +------------+ 
// | C  INCLUDE |
// +------------+
//-I../src/c

// +------------+ 
// | C FILELIST |
// +------------+ 

// +------------+ 
// |  SV DEFINE |
// +------------+ 
+define+YUU_AHB_MASTER_NUM=1
+define+YUU_AHB_SLAVE_NUM=1
+define+YUU_AHB_ADDR_WIDTH=32
+define+YUU_AHB_DATA_WIDTH=32

// +------------------+
// | INTERFACE DEFINE |
// +------------------+

// +-----------------+ 
// | PACKET FILELIST |
// +-----------------+ 
../../yuu_common/include/yuu_common_pkg.sv
../../yuu_amba/include/yuu_amba_pkg.sv
../include/yuu_ahb_pkg.sv

// +---------------+ 
// | CASE FILELIST |
// +---------------+ 

// +----------+ 
// | TOP FILE |
// +----------+ 
top.sv

// +--------------+ 
// | FILE INCLUDE |
// +--------------+ 

// +-------------+ 
// | RTL INCLUDE |
// +-------------+ 

// +--------------+
// | RTL FILELIST | 
// +--------------+

// +------------+ 
// |  Package   |
// +------------+ 
+incdir+../../yuu_common/include
+incdir+../../yuu_common/src/sv
+incdir+../../yuu_amba/include/
+incdir+../../yuu_amba/src/sv
+incdir+../include
+incdir+../src/sv/yuu_ahb_common
+incdir+../src/sv/yuu_ahb_master
+incdir+../src/sv/yuu_ahb_slave
+incdir+../src/sv/yuu_ahb_env
+incdir+../test
