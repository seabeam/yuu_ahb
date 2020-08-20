# Description

AHB error object for application error scenario of sequence  

**Inherits**: ``uvm_object``

# Properties

## Member List

| prefix | identifier |
| - | - |
| `int unsigned` | [no_error_wt](#no_error_wt) |
| `int unsigned` | [invalid_addr_wt](#invalid_addr_wt) |
| `int unsigned` | [read_only_wt](#read_only_wt) |
| `int unsigned` | [write_only_wt](#write_only_wt) |
| `int unsigned` | [corrupt_data_wt](#corrupt_data_wt) |
| `rand yuu_ahb_error_type_e` | [error_type](#error_type) |

## Properties Detailed Documentation

### `int unsigned` no_error_wt :id=no_error_wt

?> **Access**: public  
**Default**: 100  
**Description**: Randomize constraint weight of NO_ERROR  


### `int unsigned` invalid_addr_wt :id=invalid_addr_wt

?> **Access**: public  
**Default**: 0  
**Description**: Randomize constraint weight of INVALID_ADDR  


### `int unsigned` read_only_wt :id=read_only_wt

?> **Access**: public  
**Default**: 0  
**Description**: Randomize constraint weight of READ_ONLY  


### `int unsigned` write_only_wt :id=write_only_wt

?> **Access**: public  
**Default**: 0  
**Description**: Randomize constraint weight of WRITE_ONLY  


### `int unsigned` corrupt_data_wt :id=corrupt_data_wt

?> **Access**: public  
**Default**: 0  
**Description**: Randomize constraint weight of CORRUPT_DATA  


### `rand yuu_ahb_error_type_e` error_type :id=error_type

?> **Access**: public  
**Default**: -  
**Description**: Type of error scenario.  


# Function

## Prototype

| prefix | identifier |
| - | - |
| `function` | [new](#new) |

## Function Detailed Documentation

### `function` new (string name="yuu_ahb_error") :id=new

?> **Access**: public  
**Description**: Constructor of object.  


