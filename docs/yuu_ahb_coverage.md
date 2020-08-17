# Description

AHB functional coverage collector, which receives transaction out from monitor to  
process.  

**Inherits**: ``uvm_subscriber #(yuu_ahb_item)``

# Properties

## Member List

| | |
| - | - |
| `yuu_ahb_agent_config` | [cfg](#cfg) |
| `uvm_event_pool` | [events](#events) |
| `yuu_ahb_item` | [item](#item) |
| `yuu_ahb_trans_e` | [trans](#trans) |
| `yuu_ahb_response_e` | [resp](#resp) |

## Properties Detailed Documentation

### `yuu_ahb_agent_config` cfg :id=cfg

?> **Access**: public  
**Default**: -  
**Description**: AHB agent configuration object.  


### `uvm_event_pool` events :id=events

?> **Access**: public  
**Default**: -  
**Description**: Global event pool for component communication.  


### `yuu_ahb_item` item :id=item

?> **Access**: public  
**Default**: -  
**Description**: Transaction received from monitor for coverage sampling.  


### `yuu_ahb_trans_e` trans :id=trans

?> **Access**: public  
**Default**: -  
**Description**: HTRANS received from monitor for coverage sampling.  


### `yuu_ahb_response_e` resp :id=resp

?> **Access**: public  
**Default**: -  
**Description**: HRESP received from monitor for coverage sampling.  


# Function

## Prototype

| | |
| - | - |
| `function` | [new](#new) |
| `function void` | [build_phase](#build_phase) |
| `function void` | [connect_phase](#connect_phase) |
| `function void` | [write](#write) |

## Function Detailed Documentation

### `function` new (string name, uvm_component parent) :id=new

?> **Access**: public  
**Description**: Constructor of object.  


### `function void` build_phase (uvm_phase phase) :id=build_phase

?> **Access**: public  
**Description**: UVM built-in method.  


### `function void` connect_phase (uvm_phase phase) :id=connect_phase

?> **Access**: public  
**Description**: UVM built-in method.  


### `function void` write (yuu_ahb_item t) :id=write

?> **Access**: public  
**Description**: UVM built-in method. A user implementation of uvm_analysis_imp.  
In this class, user can override this method to add, remove or  
update user coverage group sampling.  


