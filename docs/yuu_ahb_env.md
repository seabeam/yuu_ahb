# Description

AHB environment class, a container of masters and slaves  

**Inherits**: ``uvm_env``

# Properties

## Member List

| prefix | identifier |
| - | - |
| `yuu_ahb_env_config` | [cfg](#cfg) |
| `yuu_ahb_master_agent` | [master[]](#master) |
| `yuu_ahb_slave_agent` | [slave[]](#slave) |
| `yuu_ahb_virtual_sequencer` | [vsequencer](#vsequencer) |

## Properties Detailed Documentation

### `yuu_ahb_env_config` cfg :id=cfg

?> **Access**: public  
**Default**: -  
**Description**: AHB agent configuration object.  


### `yuu_ahb_master_agent` master[] :id=master

?> **Access**: public  
**Default**: -  
**Description**: AHB master agent instances.  


### `yuu_ahb_slave_agent` slave[] :id=slave

?> **Access**: public  
**Default**: -  
**Description**: AHB slave agent instances.  


### `yuu_ahb_virtual_sequencer` vsequencer :id=vsequencer

?> **Access**: public  
**Default**: -  
**Description**: AHB virtual sequencer handle.  


# Function

## Prototype

| prefix | identifier |
| - | - |
| `function` | [new](#new) |
| `function void` | [build_phase](#build_phase) |
| `function void` | [connect_phase](#connect_phase) |
| `function void` | [address_check](#address_check) |

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


### `function void` address_check () :id=address_check

?> **Access**: public  
**Description**: Check master/slave's address conflict  


