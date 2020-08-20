# Description

Driver implementation of AHB slave  

**Inherits**: ``uvm_driver #(yuu_ahb_slave_item)``

# Properties

## Member List

| prefix | identifier |
| - | - |
| `virtual yuu_ahb_slave_interface` | [vif](#vif) |
| `uvm_analysis_port #(yuu_ahb_slave_item)` | [out_driver_port](#out_driver_port) |
| `yuu_ahb_slave_config` | [cfg](#cfg) |
| `uvm_event_pool` | [events](#events) |
| `protected process` | [processes[string]](#processes) |
| `protected yuu_common_addr_map` | [maps[]](#maps) |
| `protected yuu_ahb_slave_memory` | [m_mem](#m_mem) |
| `protected boolean` | [m_excl_start](#m_excl_start) |
| `protected yuu_ahb_addr_t` | [m_excl_addr](#m_excl_addr) |
| `protected int unsigned` | [m_excl_master](#m_excl_master) |
| `local int unsigned` | [drive_count](#drive_count) |

## Properties Detailed Documentation

### `virtual yuu_ahb_slave_interface` vif :id=vif

?> **Access**: public  
**Default**: -  
**Description**: AHB slave interface handle.  


### `uvm_analysis_port #(yuu_ahb_slave_item)` out_driver_port :id=out_driver_port

?> **Access**: public  
**Default**: -  
**Description**: Analysis port out from driver.  


### `yuu_ahb_slave_config` cfg :id=cfg

?> **Access**: public  
**Default**: -  
**Description**: AHB slave agent configuration object.  


### `uvm_event_pool` events :id=events

?> **Access**: public  
**Default**: -  
**Description**: Global event pool for component communication.  


### `protected process` processes[string] :id=processes

?> **Access**: protected  
**Default**: -  
**Description**: Processes for handling reset.  


### `protected yuu_common_addr_map` maps[] :id=maps

?> **Access**: protected  
**Default**: -  
**Description**: Address infomation of slave.  


### `protected yuu_ahb_slave_memory` m_mem :id=m_mem

?> **Access**: protected  
**Default**: -  
**Description**: Internal memory object of slave.  


### `protected boolean` m_excl_start :id=m_excl_start

?> **Access**: protected  
**Default**: -  
**Description**: Exclusive transfer start flag.  


### `protected yuu_ahb_addr_t` m_excl_addr :id=m_excl_addr

?> **Access**: protected  
**Default**: -  
**Description**: Address used in exclusive transfer.  


### `protected int unsigned` m_excl_master :id=m_excl_master

?> **Access**: protected  
**Default**: -  
**Description**: Master identifier used in exclusive transfer.  


### `local int unsigned` drive_count :id=drive_count

?> **Access**: local  
**Default**: -  
**Description**: Counter of drivern transaction.  


# Function

## Prototype

| prefix | identifier |
| - | - |
| `function` | [new](#new) |
| `function void` | [build_phase](#build_phase) |
| `function void` | [connect_phase](#connect_phase) |
| `function void` | [init_mem](#init_mem) |
| `function boolean` | [is_out](#is_out) |

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


### `function void` init_mem () :id=init_mem

?> **Access**: public  
**Description**: Internal memory initialize.  


### `function boolean` is_out (yuu_ahb_addr_t addr) :id=is_out

?> **Access**: public  
**Description**: Check the address is inside slave.  
Para:  
addr - the address expect to check.  


# Task

## Prototype

| prefix | identifier |
| - | - |
| `task` | [run_phase](#run_phase) |
| `task` | [init_component](#init_component) |
| `task` | [reset_signal](#reset_signal) |
| `task` | [get_and_drive](#get_and_drive) |
| `task` | [drive_bus](#drive_bus) |
| `task` | [wait_reset](#wait_reset) |

## Function Detailed Documentation

### `task` run_phase (uvm_phase phase) :id=run_phase

?> **Access**: public  
**Description**: UVM built-in method.  


### `task` init_component () :id=init_component

?> **Access**: public  
**Description**: Internal resource initialize.  


### `task` reset_signal () :id=reset_signal

?> **Access**: public  
**Description**: Reset interface signal  


### `task` get_and_drive () :id=get_and_drive

?> **Access**: public  
**Description**: Fetch transaction from sequencer and drive on bus.  


### `task` drive_bus () :id=drive_bus

?> **Access**: public  
**Description**: Drive transaction on bus.  


### `task` wait_reset () :id=wait_reset

?> **Access**: public  
**Description**: Thread of reset waiting for handle on-the-fly reset.  


