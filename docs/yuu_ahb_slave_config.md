# Description

Configuration object for AHB slave.  

**Inherits**: ``yuu_ahb_agent_config``

# Properties

## Member List

| prefix | identifier |
| - | - |
| `virtual yuu_ahb_slave_interface` | [vif](#vif) |
| `boolean` | [wait_enable](#wait_enable) |
| `yuu_common_mem_pattern_e` | [mem_init_pattern](#mem_init_pattern) |

## Properties Detailed Documentation

### `virtual yuu_ahb_slave_interface` vif :id=vif

?> **Access**: public  
**Default**: -  
**Description**: AHB bus interface handle.  


### `boolean` wait_enable :id=wait_enable

?> **Access**: public  
**Default**: True  
**Description**: The switch of slave random wait cycles.  


### `yuu_common_mem_pattern_e` mem_init_pattern :id=mem_init_pattern

?> **Access**: public  
**Default**: PATTERN_ALL_0  
**Description**: The initial pattern of built-in memory of slave driver.  


# Function

## Prototype

| prefix | identifier |
| - | - |
| `function` | [new](#new) |
| `function boolean` | [check_valid](#check_valid) |

## Function Detailed Documentation

### `function` new (string name="yuu_ahb_slave_config") :id=new

?> **Access**: public  
**Description**: Constructor of object.  


### `function boolean` check_valid () :id=check_valid

?> **Access**: public  
**Description**: Check the validity of the configuration.  


