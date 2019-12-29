-timescale=1ns/1ps
//-------------------------------------
// DUT Define 
//-------------------------------------

//-------------------------------------
// DUT Include 
//-------------------------------------

//-------------------------------------
// DUT Filelist
//-------------------------------------

//-------------------------------------
// C Define 
//-------------------------------------

//-------------------------------------
// C Include 
//-------------------------------------
//-I../src/c

//-------------------------------------
// C Filelist
//-------------------------------------

//-------------------------------------
// SV Define
//-------------------------------------
+define+YUU_AHB_MASTER_NUM=1
+define+YUU_AHB_SLAVE_NUM=1
+define+YUU_AHB_ADDR_WIDTH=32
+define+YUU_AHB_DATA_WIDTH=32

//-------------------------------------
// SV Include
//-------------------------------------
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

//-------------------------------------
// SV Filelist
//-------------------------------------
../../yuu_common/include/yuu_common_pkg.sv
../../yuu_amba/include/yuu_amba_pkg.sv
../include/yuu_ahb_pkg.sv

//-------------------------------------
// Case List
//-------------------------------------
../test/yuu_ahb_base_case.sv
../test/yuu_ahb_direct_case.sv
../test/yuu_ahb_ral_case.sv


//-------------------------------------
// Top Module
//-------------------------------------
top.sv
