# Description

Register extension for adapter.  

**Inherits**: ``uvm_object``

# Properties

## Member List

| prefix | identifier |
| - | - |
| `yuu_ahb_addr_t` | [byte_offset](#byte_offset) |
| `yuu_ahb_data_t` | [data[]](#data) |
| `yuu_ahb_size_e` | [size](#size) |
| `yuu_ahb_burst_e` | [burst](#burst) |
| `yuu_ahb_prot0_e` | [prot0](#prot0) |
| `yuu_ahb_prot1_e` | [prot1](#prot1) |
| `yuu_ahb_prot2_e` | [prot2](#prot2) |
| `yuu_ahb_prot3_e` | [prot3](#prot3) |
| `bit[3:0]` | [master](#master) |
| `bit` | [lock](#lock) |
| `yuu_ahb_nonsec_e` | [nonsec](#nonsec) |
| `yuu_ahb_excl_e` | [excl](#excl) |

## Properties Detailed Documentation

### `yuu_ahb_addr_t` byte_offset :id=byte_offset

?> **Access**: public  
**Default**: -  
**Description**: Byte address base on register address.  


### `yuu_ahb_data_t` data[] :id=data

?> **Access**: public  
**Default**: -  
**Description**: Register payload.  


### `yuu_ahb_size_e` size :id=size

?> **Access**: public  
**Default**: -  
**Description**: User defined HSIZE.  


### `yuu_ahb_burst_e` burst :id=burst

?> **Access**: public  
**Default**: yuu_ahb_pkg::INCR  
**Description**: User defined HBURST.  


### `yuu_ahb_prot0_e` prot0 :id=prot0

?> **Access**: public  
**Default**: DATA_ACCESS  
**Description**: User defined HPROT[0].  


### `yuu_ahb_prot1_e` prot1 :id=prot1

?> **Access**: public  
**Default**: PRIVILEGED_ACCESS  
**Description**: User defined HPROT[1].  


### `yuu_ahb_prot2_e` prot2 :id=prot2

?> **Access**: public  
**Default**: NON_BUFFERABLE  
**Description**: User defined HPROT[2].  


### `yuu_ahb_prot3_e` prot3 :id=prot3

?> **Access**: public  
**Default**: NON_CACHEABLE  
**Description**: User defined HPROT[3].  


### `bit[3:0]` master :id=master

?> **Access**: public  
**Default**: -  
**Description**: User defined HMASTER.  


### `bit` lock :id=lock

?> **Access**: public  
**Default**: -  
**Description**: User defined HMASTLOCK.  


### `yuu_ahb_nonsec_e` nonsec :id=nonsec

?> **Access**: public  
**Default**: NON_SECURE  
**Description**: User defined HNONSEC.  


### `yuu_ahb_excl_e` excl :id=excl

?> **Access**: public  
**Default**: NON_EXCLUSIVE  
**Description**: User defined HEXCL.  


# Function

## Prototype

| prefix | identifier |
| - | - |
| `function` | [new](#new) |

## Function Detailed Documentation

### `function` new (string name="yuu_ahb_reg_extension") :id=new

?> **Access**: public  
**Description**: Constructor of object.  


