# Description

Driver implementation of AHB master  

**Inherits**: ``uvm_driver #(yuu_ahb_master_item)``

# Properties

## Member List

| prefix | identifier |
| - | - |
| `virtual yuu_ahb_master_interface` | [vif](#vif) |
| `uvm_analysis_port #(yuu_ahb_master_item)` | [out_driver_port](#out_driver_port) |
| `yuu_ahb_master_config` | [cfg](#cfg) |
| `uvm_event_pool` | [events](#events) |
| `protected process` | [processes[string]](#processes) |
| `protected semaphore` | [m_cmd_sem](#m_cmd_sem) |
| `protected semaphore` | [m_data_sem](#m_data_sem) |
| `boolean` | [error_key](#error_key) |

## Properties Detailed Documentation

### `virtual yuu_ahb_master_interface` vif :id=vif

?> **Access**: public  
**Default**: -  
**Description**: AHB master interface handle.  


### `uvm_analysis_port #(yuu_ahb_master_item)` out_driver_port :id=out_driver_port

?> **Access**: public  
**Default**: -  
**Description**: Analysis port out from driver.  


### `yuu_ahb_master_config` cfg :id=cfg

?> **Access**: public  
**Default**: -  
**Description**: AHB master agent configuration object.  


### `uvm_event_pool` events :id=events

?> **Access**: public  
**Default**: -  
**Description**: Global event pool for component communication.  


### `protected process` processes[string] :id=processes

?> **Access**: protected  
**Default**: -  
**Description**: Processes for handling reset.  


### `protected semaphore` m_cmd_sem :id=m_cmd_sem

?> **Access**: protected  
**Default**: -  
**Description**: Semaphore for pipeline in command phase.  


### `protected semaphore` m_data_sem :id=m_data_sem

?> **Access**: protected  
**Default**: -  
**Description**: Semaphore for pipeline in data phase.  


### `boolean` error_key :id=error_key

?> **Access**: public  
**Default**: False  
**Description**: Error process flag  


# Function

## Prototype

| prefix | identifier |
| - | - |
| `function` | [new](#new) |
| `function void` | [build_phase](#build_phase) |
| `function void` | [connect_phase](#connect_phase) |

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


# Task

## Prototype

| prefix | identifier |
| - | - |
| `task` | [run_phase](#run_phase) |
| `task` | [init_component](#init_component) |
| `task` | [reset_signal](#reset_signal) |
| `task` | [get_and_drive](#get_and_drive) |
| `task` | [cmd_phase](#cmd_phase) |
| `task` | [data_phase](#data_phase) |
| `task` | [send_response](#send_response) |
| `task` | [wait_reset](#wait_reset) |
| `task` | [error_proc](#error_proc) |

## Function Detailed Documentation

### `task` run_phase (uvm_phase phase) :id=run_phase

?> **Access**: public  
**Description**: UVM built-in method.  


### `task` init_component () :id=init_component

?> **Access**: public  
**Description**: Internal resource initialize.  


### `task` reset_signal () :id=reset_signal

?> **Access**: public  
**Description**: Reset interface signal.  


### `task` get_and_drive () :id=get_and_drive

?> **Access**: public  
**Description**: Fetch transaction from sequencer and drive on bus.  


### `task` cmd_phase (input yuu_ahb_master_item item) :id=cmd_phase

?> **Access**: public  
**Description**: Main drive task, command phase.  
Para:  
item - item expect to drive  


### `task` data_phase (input yuu_ahb_master_item item) :id=data_phase

?> **Access**: public  
**Description**: Main drive task, data phase.  
Para:  
item - item expect to drive  


### `task` send_response (input yuu_ahb_master_item item) :id=send_response

?> **Access**: public  
**Description**: Send response back to sequencer.  
Para:  
item - the transaction after driving on bus  


### `task` wait_reset () :id=wait_reset

?> **Access**: public  
**Description**: Thread of reset waiting for handle on-the-fly reset.  


### `task` error_proc () :id=error_proc

?> **Access**: public  
**Description**: Response error detect, then set the error flag for processing.  


