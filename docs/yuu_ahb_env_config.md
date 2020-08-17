# Description

Configuration class for AHB environment.  

**Inherits**: ``uvm_object``

# Properties

## Member List

| | |
| - | - |
| `virtual yuu_ahb_interface` | [ahb_if](#ahb_if) |
| `uvm_event_pool` | [events](#events) |
| `yuu_ahb_master_config` | [mst_cfg[$]](#mst_cfg) |
| `yuu_ahb_slave_config` | [slv_cfg[$]](#slv_cfg) |
| `boolean` | [compare_enable](#compare_enable) |
| `boolean` | [protocol_check_enable](#protocol_check_enable) |

## Properties Detailed Documentation

### `virtual yuu_ahb_interface` ahb_if :id=ahb_if

?> **Access**: public  
**Default**: -  
**Description**: AHB bus interface handle.  


### `uvm_event_pool` events :id=events

?> **Access**: public  
**Default**: -  
**Description**: Global event pool for component communication.  


### `yuu_ahb_master_config` mst_cfg[$] :id=mst_cfg

?> **Access**: public  
**Default**: -  
**Description**: AHB master configuration pool.  


### `yuu_ahb_slave_config` slv_cfg[$] :id=slv_cfg

?> **Access**: public  
**Default**: -  
**Description**: AHB slave configuration pool.  


### `boolean` compare_enable :id=compare_enable

?> **Access**: public  
**Default**: False  
**Description**: Enable scoreboard.  


### `boolean` protocol_check_enable :id=protocol_check_enable

?> **Access**: public  
**Default**: False  
**Description**: Bus protocol check enable.  


# Function

## Prototype

| | |
| - | - |
| `function` | [new](#new) |
| `function void` | [set_config](#set_config) |
| `function void` | [set_configs](#set_configs) |
| `function boolean` | [check_valid](#check_valid) |

## Function Detailed Documentation

### `function` new (string name="yuu_ahb_env_config") :id=new

?> **Access**: public  
**Description**: Constructor of object.  


### `function void` set_config (yuu_ahb_agent_config cfg) :id=set_config

?> **Access**: public  
**Description**: Set user configuration to environment configuration pool.  
Para:  
cfg - Agent configuration.  


### `function void` set_configs (yuu_ahb_agent_config cfg[]) :id=set_configs

?> **Access**: public  
**Description**: Set user configurations to environment configuration pool.  
Para:  
cfg - Agent configurations array.  


### `function boolean` check_valid () :id=check_valid

?> **Access**: public  
**Description**: Check the validity of the configuration.  


