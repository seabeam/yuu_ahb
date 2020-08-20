# Description

The base class for AHB slave sequence.  

**Inherits**: ``uvm_sequence #(yuu_ahb_slave_item)``

# Properties

## Member List

| prefix | identifier |
| - | - |
| `virtual yuu_ahb_slave_interface` | [vif](#vif) |
| `yuu_ahb_slave_config` | [cfg](#cfg) |
| `uvm_event_pool` | [events](#events) |
| `yuu_ahb_error` | [error_object](#error_object) |

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


### `yuu_ahb_error` error_object :id=error_object

?> **Access**: public  
**Default**: -  
**Description**: Error object for application.  


# Function

## Prototype

| prefix | identifier |
| - | - |
| `function` | [new](#new) |

## Function Detailed Documentation

### `function` new (string name="yuu_ahb_slave_sequence_base") :id=new

?> **Access**: public  
**Description**: Constructor of object.  


# Task

## Prototype

| prefix | identifier |
| - | - |
| `task` | [pre_start](#pre_start) |
| `task` | [body](#body) |

## Function Detailed Documentation

### `task` pre_start () :id=pre_start

?> **Access**: public  
**Description**: UVM built-in method.  


### `task` body () :id=body

?> **Access**: public  
**Description**: UVM built-in method.  


