# Description

Configuration class for AHB master.  

**Inherits**: ``yuu_ahb_agent_config``

# Properties

## Member List

| prefix | identifier |
| - | - |
| `virtual yuu_ahb_master_interface` | [vif](#vif) |
| `boolean` | [idle_enable](#idle_enable) |
| `boolean` | [busy_enable](#busy_enable) |
| `boolean` | [use_busy_end](#use_busy_end) |
| `boolean` | [use_protection_transfers](#use_protection_transfers) |
| `boolean` | [use_extended_memory_types](#use_extended_memory_types) |
| `boolean` | [use_locked_transfers](#use_locked_transfers) |
| `boolean` | [use_secure_transfers](#use_secure_transfers) |
| `boolean` | [use_exclusive_transfers](#use_exclusive_transfers) |
| `boolean` | [use_response](#use_response) |
| `boolean` | [use_reg_model](#use_reg_model) |
| `yuu_ahb_error_behavior_e` | [error_behavior](#error_behavior) |

## Properties Detailed Documentation

### `virtual yuu_ahb_master_interface` vif :id=vif

?> **Access**: public  
**Default**: -  
**Description**: AHB master interface handle.  


### `boolean` idle_enable :id=idle_enable

?> **Access**: public  
**Default**: True  
**Description**: Switch of IDLE trans between transactions sent out from master.  


### `boolean` busy_enable :id=busy_enable

?> **Access**: public  
**Default**: True  
**Description**: Switch of busy trans during transaction sent out from master.  


### `boolean` use_busy_end :id=use_busy_end

?> **Access**: public  
**Default**: False  
**Description**: Transaction randomize with BUSY trans in last transfer or not.  


### `boolean` use_protection_transfers :id=use_protection_transfers

?> **Access**: public  
**Default**: False  
**Description**: Transaction randomize with protection information or not.  


### `boolean` use_extended_memory_types :id=use_extended_memory_types

?> **Access**: public  
**Default**: False  
**Description**: Transaction randomize with extended memory types information or not.  


### `boolean` use_locked_transfers :id=use_locked_transfers

?> **Access**: public  
**Default**: False  
**Description**: Transaction randomize with locked transfers information or not.  


### `boolean` use_secure_transfers :id=use_secure_transfers

?> **Access**: public  
**Default**: False  
**Description**: Transaction randomize with secure transfers information or not.  


### `boolean` use_exclusive_transfers :id=use_exclusive_transfers

?> **Access**: public  
**Default**: False  
**Description**: Transaction randomize with exclusive transfers information or not.  


### `boolean` use_response :id=use_response

?> **Access**: public  
**Default**: False  
**Description**: Switch of AHB master wait response from connected slave.  


### `boolean` use_reg_model :id=use_reg_model

?> **Access**: public  
**Default**: False  
**Description**: Switch of instantiating register related components like adapter,  
predictor. When this option is True, the use_response will be  
also set to True.  


### `yuu_ahb_error_behavior_e` error_behavior :id=error_behavior

?> **Access**: public  
**Default**: CONTINUE_AFTER_ERROR  
**Description**: Behavior of AHB master get a error response. Either continue or  
abort can be chosen.  


# Function

## Prototype

| prefix | identifier |
| - | - |
| `function` | [new](#new) |
| `function boolean` | [check_valid](#check_valid) |

## Function Detailed Documentation

### `function` new (string name="yuu_ahb_master_config") :id=new

?> **Access**: public  
**Description**: Constructor of object.  


### `function boolean` check_valid () :id=check_valid

?> **Access**: public  
**Description**: Check the validity of the configuration.  


