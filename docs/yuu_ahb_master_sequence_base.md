# Description

The base class for AHB master sequence.  

**Inherits**: ``uvm_sequence #(yuu_ahb_master_item)``

# Properties

## Member List

| prefix | identifier |
| - | - |
| `virtual yuu_ahb_master_interface` | [vif](#vif) |
| `yuu_ahb_master_config` | [cfg](#cfg) |
| `uvm_event_pool` | [events](#events) |
| `int unsigned` | [n_item](#n_item) |

## Properties Detailed Documentation

### `virtual yuu_ahb_master_interface` vif :id=vif

?> **Access**: public  
**Default**: -  
**Description**: AHB master interface handle.  


### `yuu_ahb_master_config` cfg :id=cfg

?> **Access**: public  
**Default**: -  
**Description**: AHB master agent configuration object.  


### `uvm_event_pool` events :id=events

?> **Access**: public  
**Default**: -  
**Description**: Global event pool for component communication.  


### `int unsigned` n_item :id=n_item

?> **Access**: public  
**Default**: 10  
**Description**: Transaction number which expect to send.  


# Function

## Prototype

| prefix | identifier |
| - | - |
| `function` | [new](#new) |

## Function Detailed Documentation

### `function` new (string name="yuu_ahb_master_sequence_base") :id=new

?> **Access**: public  
**Description**: Constructor of object.  


# Task

## Prototype

| prefix | identifier |
| - | - |
| `virtual task` | [pre_start](#pre_start) |
| `virtual task` | [body](#body) |

## Function Detailed Documentation

### `virtual task` pre_start () :id=pre_start

?> **Access**: public  
**Description**: UVM built-in method.  


### `virtual task` body () :id=body

?> **Access**: public  
**Description**: UVM built-in method.  


