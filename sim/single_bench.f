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
+incdir+../include
+incdir+../src/sv
+incdir+../test

//-------------------------------------
// SV Filelist
//-------------------------------------
../../yuu_common/include/yuu_common_pkg.sv
../include/yuu_ahb_pkg.sv

//-------------------------------------
// Case List
//-------------------------------------
../test/yuu_ahb_base_case.sv
../test/yuu_ahb_direct_case.sv
../test/yuu_ahb_ral_case.sv
../test/yuu_ahb_single_base_case.sv
../test/yuu_ahb_single_direct_case.sv


//-------------------------------------
// Top Module
//-------------------------------------
single_top.sv
