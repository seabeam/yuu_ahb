# Description

Sequencer implementation of AHB slave  

**Inherits**: ``uvm_sequencer #(yuu_ahb_slave_item)``

# Properties

## Member List

| | |
| - | - |
| `virtual yuu_ahb_slave_interface` | [vif](#vif) |
| `yuu_ahb_slave_config` | [cfg](#cfg) |
| `uvm_event_pool` | [events](#events) |

## Properties Detailed Documentation

### `virtual yuu_ahb_slave_interface` vif :id=vif

?> **Access**: public  
**Default**: -  
**Description**: AHB slave interface handle.  


### `yuu_ahb_slave_config` cfg :id=cfg

?> **Access**: public  
**Default**: -  
**Description**: AHB slave agent configuration object.  


### `uvm_event_pool` events :id=events

?> **Access**: public  
**Default**: -  
**Description**: Global event pool for component communication.  


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


