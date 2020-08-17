# Description

AHB base transaction.  

**Inherits**: ``uvm_sequence_item``

# Constraint

## c_ahb_size
**Description**:

Size of payload, response and burst_size constraint.  

```verilog
constraint c_ahb_size {  
  data.size()==len+1;  
  response.size()==len+1;  
  burst_size <=$clog2(`YUU_AHB_MAX_DATA_WIDTH/8);  
}  

```

## c_ahb_align
**Description**:

Address alignment constraint.  

```verilog
constraint c_ahb_align {  
  address_aligned_enable==True;  
  burst_type==AHB_WRAP -> address_aligned_enable==True;  
  if (address_aligned_enable) {  
    burst_size==BYTE2 -> start_address[0]==1'b0;  
    burst_size==BYTE4 -> start_address[1:0]==2'b0;  
    burst_size==BYTE8 -> start_address[2:0]==3'b0;  
    burst_size==BYTE16 -> start_address[3:0]==4'b0;  
    burst_size==BYTE32 -> start_address[4:0]==5'b0;  
    burst_size==BYTE64 -> start_address[5:0]==6'b0;  
    burst_size==BYTE128 -> start_address[6:0]==7'b0;  
  }  

```

## c_ahb_burst_type
**Description**:

burst and len constraint.  

```verilog
constraint c_ahb_burst_type {  
  burst==SINGLE -> len==1-1;  
  burst inside {INCR4, WRAP4} -> len==4-1;  
  burst inside {INCR8, WRAP8} -> len==8-1;  
  burst inside {INCR16, WRAP16} -> len==16-1;  
  (burst inside {SINGLE, INCR, INCR4, INCR8, INCR16}) <-> burst_type==AHB_INCR;  
  (burst inside {WRAP4, WRAP8, WRAP16}) <-> burst_type==AHB_WRAP;  
  soft burst dist {SINGLE:/10, INCR4:/20, INCR8:/20, INCR16:/20, INCR:/21, WRAP4:/3, WRAP8:/3, WRAP16:/3};  
}  

```

## c_ahb_burst_size
**Description**:

size and burst_size constraint.  

```verilog
constraint c_ahb_burst_size {  
  size==SIZE8 <-> burst_size==BYTE1;  
  size==SIZE16 <-> burst_size==BYTE2;  
  size==SIZE32 <-> burst_size==BYTE4;  
  size==SIZE64 <-> burst_size==BYTE8;  
  size==SIZE128 <-> burst_size==BYTE16;  
  size==SIZE256 <-> burst_size==BYTE32;  
  size==SIZE512 <-> burst_size==BYTE64;  
  size==SIZE1024 <-> burst_size==BYTE128;  
}  

```

## c_ahb_exclusive
**Description**:

excl and len constraint.  

```verilog
constraint c_ahb_exclusive {  
  excl==1'b1 -> len==0;  
}  

```

## c_ahb_1k_boundary
**Description**:

Burst address should never cross 1K boundary.  

```verilog
constraint c_ahb_1k_boundary {  
  if (burst_type==AHB_INCR) {  
    start_address[9:0]+(len+1)*number_bytes <=1024;  
  }  

```
# Properties

## Member List

| | |
| - | - |
| `rand yuu_ahb_addr_t` | [start_address](#start_address) |
| `rand yuu_ahb_data_t` | [data[]](#data) |
| `rand int unsigned` | [len](#len) |
| `yuu_ahb_trans_e` | [trans[]](#trans) |
| `rand yuu_ahb_response_e` | [response[]](#response) |
| `rand yuu_ahb_direction_e` | [direction](#direction) |
| `rand yuu_ahb_burst_size_e` | [burst_size](#burst_size) |
| `rand yuu_ahb_size_e` | [size](#size) |
| `rand yuu_ahb_burst_e` | [burst](#burst) |
| `rand yuu_ahb_burst_type_e` | [burst_type](#burst_type) |
| `rand yuu_ahb_prot0_e` | [prot0](#prot0) |
| `rand yuu_ahb_prot1_e` | [prot1](#prot1) |
| `rand yuu_ahb_prot2_e` | [prot2](#prot2) |
| `rand yuu_ahb_prot3_e` | [prot3](#prot3) |
| `rand yuu_ahb_emt_prot3_e` | [prot3_emt](#prot3_emt) |
| `rand yuu_ahb_emt_prot4_e` | [prot4_emt](#prot4_emt) |
| `rand yuu_ahb_emt_prot5_e` | [prot5_emt](#prot5_emt) |
| `rand yuu_ahb_emt_prot6_e` | [prot6_emt](#prot6_emt) |
| `bit[3:0]` | [master](#master) |
| `rand bit` | [lock](#lock) |
| `rand yuu_ahb_nonsec_e` | [nonsec](#nonsec) |
| `rand yuu_ahb_excl_e` | [excl](#excl) |
| `rand yuu_ahb_exokay_e` | [exokay](#exokay) |
| `yuu_ahb_addr_t` | [address[]](#address) |
| `yuu_ahb_addr_t` | [aligned_address](#aligned_address) |
| `yuu_ahb_addr_t` | [low_boundary](#low_boundary) |
| `yuu_ahb_addr_t` | [high_boundary](#high_boundary) |
| `yuu_ahb_addr_t` | [wrap_boundary](#wrap_boundary) |
| `yuu_ahb_lane_t` | [lower_byte_lane[]](#lower_byte_lane) |
| `yuu_ahb_lane_t` | [upper_byte_lane[]](#upper_byte_lane) |
| `int unsigned` | [number_bytes](#number_bytes) |
| `int unsigned` | [burst_length](#burst_length) |
| `int unsigned` | [data_bus_bytes](#data_bus_bytes) |
| `rand boolean` | [address_aligned_enable](#address_aligned_enable) |
| `yuu_ahb_location_e` | [location[]](#location) |
| `real` | [start_time](#start_time) |
| `real` | [end_time](#end_time) |

## Properties Detailed Documentation

### `rand yuu_ahb_addr_t` start_address :id=start_address

?> **Access**: public  
**Default**: -  
**Description**: The start address issued by the master.  


### `rand yuu_ahb_data_t` data[] :id=data

?> **Access**: public  
**Default**: -  
**Description**: The transaction payload.  


### `rand int unsigned` len :id=len

?> **Access**: public  
**Default**: -  
**Description**: The burst length.  


### `yuu_ahb_trans_e` trans[] :id=trans

?> **Access**: public  
**Default**: -  
**Description**: The trans information. Used by HTRANS.  


### `rand yuu_ahb_response_e` response[] :id=response

?> **Access**: public  
**Default**: -  
**Description**: The response information. Used by HRESP.  


### `rand yuu_ahb_direction_e` direction :id=direction

?> **Access**: public  
**Default**: -  
**Description**: The direction information. Used by HWRITE.  


### `rand yuu_ahb_burst_size_e` burst_size :id=burst_size

?> **Access**: public  
**Default**: -  
**Description**: (AMBA) The size of burst, 1 byte, 2 bytes etc.  


### `rand yuu_ahb_size_e` size :id=size

?> **Access**: public  
**Default**: -  
**Description**: The size information. Used by HSIZE.  


### `rand yuu_ahb_burst_e` burst :id=burst

?> **Access**: public  
**Default**: -  
**Description**: The burst information. Used by HBURST.  


### `rand yuu_ahb_burst_type_e` burst_type :id=burst_type

?> **Access**: public  
**Default**: -  
**Description**: (AMBA) The type of burst:FIXED, INCR or WRAP.  


### `rand yuu_ahb_prot0_e` prot0 :id=prot0

?> **Access**: public  
**Default**: DATA_ACCESS  
**Description**: The protection control information. Used by HPROT[0].  


### `rand yuu_ahb_prot1_e` prot1 :id=prot1

?> **Access**: public  
**Default**: PRIVILEGED_ACCESS  
**Description**: The protection control information. Used by HPROT[1].  


### `rand yuu_ahb_prot2_e` prot2 :id=prot2

?> **Access**: public  
**Default**: NON_BUFFERABLE  
**Description**: The protection control information. Used by HPROT[2].  


### `rand yuu_ahb_prot3_e` prot3 :id=prot3

?> **Access**: public  
**Default**: NON_CACHEABLE  
**Description**: The protection control information. Used by HPROT[3].  


### `rand yuu_ahb_emt_prot3_e` prot3_emt :id=prot3_emt

?> **Access**: public  
**Default**: NON_MODIFIABLE  
**Description**: The protection control information, extended memory type. Used by HPROT[3].  


### `rand yuu_ahb_emt_prot4_e` prot4_emt :id=prot4_emt

?> **Access**: public  
**Default**: NO_LOOKUP  
**Description**: The protection control information, extended memory type. Used by HPROT[4].  


### `rand yuu_ahb_emt_prot5_e` prot5_emt :id=prot5_emt

?> **Access**: public  
**Default**: NO_ALLOCATE  
**Description**: The protection control information, extended memory type. Used by HPROT[5].  


### `rand yuu_ahb_emt_prot6_e` prot6_emt :id=prot6_emt

?> **Access**: public  
**Default**: NON_SHAREABLE  
**Description**: The protection control information, extended memory type. Used by HPROT[6].  


### `bit[3:0]` master :id=master

?> **Access**: public  
**Default**: -  
**Description**: The master identifier information. Used by HMASTER.  


### `rand bit` lock :id=lock

?> **Access**: public  
**Default**: 1'b0  
**Description**: The locked transfer information. Used by HMASTLOCK.  


### `rand yuu_ahb_nonsec_e` nonsec :id=nonsec

?> **Access**: public  
**Default**: NON_SECURE  
**Description**: The secure transfer information. Used by HNONSEC.  


### `rand yuu_ahb_excl_e` excl :id=excl

?> **Access**: public  
**Default**: NON_EXCLUSIVE  
**Description**: The exclusive transfer information. Used by HEXCL.  


### `rand yuu_ahb_exokay_e` exokay :id=exokay

?> **Access**: public  
**Default**: EXOKAY  
**Description**: The exclusive response information. Used by HEXOKAY.  


### `yuu_ahb_addr_t` address[] :id=address

?> **Access**: public  
**Default**: -  
**Description**: The address of transfer N in a burst.  


### `yuu_ahb_addr_t` aligned_address :id=aligned_address

?> **Access**: public  
**Default**: -  
**Description**: The aligned version of the start address.  


### `yuu_ahb_addr_t` low_boundary :id=low_boundary

?> **Access**: public  
**Default**: -  
**Description**: The lowest address of burst  


### `yuu_ahb_addr_t` high_boundary :id=high_boundary

?> **Access**: public  
**Default**: -  
**Description**: The highest address of burst  


### `yuu_ahb_addr_t` wrap_boundary :id=wrap_boundary

?> **Access**: public  
**Default**: -  
**Description**: The lowest address within a wrapping burst.  


### `yuu_ahb_lane_t` lower_byte_lane[] :id=lower_byte_lane

?> **Access**: public  
**Default**: -  
**Description**: The byte lane of the lowest addressed byte of a transfer.  


### `yuu_ahb_lane_t` upper_byte_lane[] :id=upper_byte_lane

?> **Access**: public  
**Default**: -  
**Description**: The byte lane of the highest addressed byte of a transfer.  


### `int unsigned` number_bytes :id=number_bytes

?> **Access**: public  
**Default**: -  
**Description**: The maximum number of bytes in each data transfer.  


### `int unsigned` burst_length :id=burst_length

?> **Access**: public  
**Default**: -  
**Description**: The total number of data transfers within a burst.  


### `int unsigned` data_bus_bytes :id=data_bus_bytes

?> **Access**: public  
**Default**: -  
**Description**: The number of byte lanes in the data bus.  


### `rand boolean` address_aligned_enable :id=address_aligned_enable

?> **Access**: public  
**Default**: False  
**Description**: Enable address aligned.  


### `yuu_ahb_location_e` location[] :id=location

?> **Access**: public  
**Default**: -  
**Description**: Transfer location.  


### `real` start_time :id=start_time

?> **Access**: public  
**Default**: -  
**Description**: The start time of transaction assert on bus.  


### `real` end_time :id=end_time

?> **Access**: public  
**Default**: -  
**Description**: The end time of transaction deassert on bus.  


# Function

## Prototype

| | |
| - | - |
| `function` | [new](#new) |
| `function void` | [post_randomize](#post_randomize) |
| `function void` | [common_process](#common_process) |
| `function void` | [command_process](#command_process) |
| `function void` | [data_process](#data_process) |

## Function Detailed Documentation

### `function` new (string name="yuu_ahb_item") :id=new

?> **Access**: public  
**Description**: Constructor of object.  


### `function void` post_randomize () :id=post_randomize

?> **Access**: public  
**Description**: SV built-in function.  


### `function void` common_process () :id=common_process

?> **Access**: public  
**Description**: Process AMBA common properties.  


### `function void` command_process () :id=command_process

?> **Access**: public  
**Description**: Process AHB command information.  


### `function void` data_process () :id=data_process

?> **Access**: public  
**Description**: Process AHB data information.  


