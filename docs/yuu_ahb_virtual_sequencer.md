# Description

AHB virtual sequencer base.  

**Inherits**: ``uvm_virtual_sequencer``

# Properties

## Member List

| | |
| - | - |
| `virtual yuu_ahb_interface` | [vif](#vif) |
| `yuu_ahb_env_config` | [cfg](#cfg) |
| `uvm_event_pool` | [events](#events) |
| `yuu_ahb_master_sequencer` | [master_sequencer[]](#master_sequencer) |
| `yuu_ahb_slave_sequencer` | [slave_sequencer[]](#slave_sequencer) |

## Properties Detailed Documentation

### `virtual yuu_ahb_interface` vif :id=vif

?> **Access**: public  
**Default**: -  
**Description**: AHB bus interface handle.  


### `yuu_ahb_env_config` cfg :id=cfg

?> **Access**: public  
**Default**: -  
**Description**: AHB environment configuration object.  


### `uvm_event_pool` events :id=events

?> **Access**: public  
**Default**: -  
**Description**: Global event pool for component communication.  


### `yuu_ahb_master_sequencer` master_sequencer[] :id=master_sequencer

?> **Access**: public  
**Default**: -  
**Description**: All master sequencer collection.  


### `yuu_ahb_slave_sequencer` slave_sequencer[] :id=slave_sequencer

?> **Access**: public  
**Default**: -  
**Description**: All slave sequencer collection.  


# Function

## Prototype

| | |
| - | - |
| `function` | [new](#new) |
| `function void` | [connect_phase](#connect_phase) |

## Function Detailed Documentation

### `function` new (string name, uvm_component parent) :id=new

?> **Access**: public  
**Description**: Constructor of object.  


### `function void` connect_phase (uvm_phase phase) :id=connect_phase

?> **Access**: public  
**Description**: UVM built-in method.  


