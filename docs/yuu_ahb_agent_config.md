# Description

Configuration object of yuu_ahb_agent, which is a base class for AHB master/slave  
agent configuration. This class includes most setting of AHB agent.  

**Inherits**: ``uvm_object``

# Properties

## Member List

| | |
| - | - |
| `uvm_event_pool` | [events](#events) |
| `int` | [index](#index) |
| `real` | [timeout](#timeout) |
| `int unsigned` | [addr_width](#addr_width) |
| `int unsigned` | [data_width](#data_width) |
| `boolean` | [analysis_enable](#analysis_enable) |
| `boolean` | [coverage_enable](#coverage_enable) |
| `boolean` | [protocol_check_enable](#protocol_check_enable) |
| `yuu_common_addr_map` | [maps[]](#maps) |
| `protected boolean` | [multi_range](#multi_range) |
| `uvm_active_passive_enum` | [is_active](#is_active) |

## Properties Detailed Documentation

### `uvm_event_pool` events :id=events

?> **Access**: public  
**Default**: -  
**Description**: Global event pool for component communication.  


### `int` index :id=index

?> **Access**: public  
**Default**: -1  
**Description**: Index of agent, by default is -1. It must be set to a non-nagetive integer which  
the agent is not reserved.  


### `real` timeout :id=timeout

?> **Access**: public  
**Default**: 0  
**Description**: Timeout setting of agent.  


### `int unsigned` addr_width :id=addr_width

?> **Access**: public  
**Default**: `YUU_AHB_MAX_ADDR_WIDTH  
**Description**: Address width of HADDR, default value is 32.  


### `int unsigned` data_width :id=data_width

?> **Access**: public  
**Default**: `YUU_AHB_MAX_DATA_WIDTH  
**Description**: Data width of HWDATA/HRADATA, default value is 32.  


### `boolean` analysis_enable :id=analysis_enable

?> **Access**: public  
**Default**: False  
**Description**: Enable throughput analysis component of agent.  


### `boolean` coverage_enable :id=coverage_enable

?> **Access**: public  
**Default**: False  
**Description**: Enable functional coverage collection component of agent.  


### `boolean` protocol_check_enable :id=protocol_check_enable

?> **Access**: public  
**Default**: True  
**Description**: Enable AHB protocol checker for agent.  


### `yuu_common_addr_map` maps[] :id=maps

?> **Access**: public  
**Default**: -  
**Description**: The address(es) which master can access, or the address(es)  
of slave.  


### `protected boolean` multi_range :id=multi_range

?> **Access**: protected  
**Default**: False  
**Description**: If the agent has multiple address range.  


### `uvm_active_passive_enum` is_active :id=is_active

?> **Access**: public  
**Default**: UVM_ACTIVE  
**Description**: When agent set to ACTIVE the sequencer and driver will be worked.  
Otherwise only monitor is working.  


# Function

## Prototype

| | |
| - | - |
| `function yuu_ahb_agent_config::new` | [](#) |
| `function boolean` | [check_valid](#check_valid) |
| `function void` | [set_map](#set_map) |
| `function void` | [set_maps](#set_maps) |
| `function yuu_common_addr_map` | [get_map](#get_map) |
| `function void` | [get_maps](#get_maps) |
| `function boolean` | [is_multi_range](#is_multi_range) |

## Function Detailed Documentation

### `function yuu_ahb_agent_config::new`  (string name="yuu_ahb_agent_config") :id=

?> **Access**: public  
**Description**: Constructor of object.  


### `function boolean` check_valid () :id=check_valid

?> **Access**: public  
**Description**: Check the validity of the configuration.  


### `function void` set_map (yuu_ahb_addr_t low, yuu_ahb_addr_t high) :id=set_map

?> **Access**: public  
**Description**: 
Set master/slave address range  
Para:  
low - (yuu_ahb_addr_t) low address boundary  
high - (yuu_ahb_addr_t) high address boundary  


### `function void` set_maps (yuu_ahb_addr_t lows[], yuu_ahb_addr_t highs[]) :id=set_maps

?> **Access**: public  
**Description**: 
Set master/slave address ranges  
Para:  
low - low address boundaries  
high - high address boundaries  


### `function yuu_common_addr_map` get_map () :id=get_map

?> **Access**: public  
**Description**: 
get all master/slave address range  


### `function void` get_maps (ref yuu_common_addr_map maps[]) :id=get_maps

?> **Access**: public  
**Description**: 
get all master/slave address ranges  
Para:  
maps - address maps information of agent  


### `function boolean` is_multi_range () :id=is_multi_range

?> **Access**: public  
**Description**: 
Return agent has multiple address ranges or not  


