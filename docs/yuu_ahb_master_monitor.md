# Description

Monitor implementation of AHB master  

**Inherits**: ``uvm_monitor``

# Properties

## Member List

| | |
| - | - |
| `virtual yuu_ahb_master_interface` | [vif](#vif) |
| `uvm_analysis_port #(yuu_ahb_item)` | [out_monitor_port](#out_monitor_port) |
| `yuu_ahb_master_config` | [cfg](#cfg) |
| `uvm_event_pool` | [events](#events) |
| `protected process` | [processes[string]](#processes) |
| `protected semaphore` | [m_cmd_sem](#m_cmd_sem) |
| `protected semaphore` | [m_data_sem](#m_data_sem) |
| `protected yuu_ahb_master_item` | [monitor_item](#monitor_item) |
| `protected yuu_ahb_addr_t` | [address_q[$]](#address_q) |
| `protected yuu_ahb_data_t` | [data_q[$]](#data_q) |
| `protected yuu_ahb_trans_e` | [trans_q[$]](#trans_q) |
| `protected yuu_ahb_response_e` | [response_q[$]](#response_q) |
| `protected yuu_ahb_exokay_e` | [exokay_q[$]](#exokay_q) |
| `protected int unsigned` | [busy_q[$]](#busy_q) |
| `protected int unsigned` | [idle_q[$]](#idle_q) |

## Properties Detailed Documentation

### `virtual yuu_ahb_master_interface` vif :id=vif

?> **Access**: public  
**Default**: -  
**Description**: AHB master interface handle.  


### `uvm_analysis_port #(yuu_ahb_item)` out_monitor_port :id=out_monitor_port

?> **Access**: public  
**Default**: -  
**Description**: Analysis port out from monitor.  


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
**Description**: Processes for handling reset  


### `protected semaphore` m_cmd_sem :id=m_cmd_sem

?> **Access**: protected  
**Default**: -  
**Description**: Semaphore for pipeline in command phase.  


### `protected semaphore` m_data_sem :id=m_data_sem

?> **Access**: protected  
**Default**: -  
**Description**: Semaphore for pipeline in data phase.  


### `protected yuu_ahb_master_item` monitor_item :id=monitor_item

?> **Access**: protected  
**Default**: -  
**Description**: Collected item send out monitor for further analyzing.  


### `protected yuu_ahb_addr_t` address_q[$] :id=address_q

?> **Access**: protected  
**Default**: -  
**Description**: Address queue to store temporary address information.  


### `protected yuu_ahb_data_t` data_q[$] :id=data_q

?> **Access**: protected  
**Default**: -  
**Description**: Data queue to store temporary data information.  


### `protected yuu_ahb_trans_e` trans_q[$] :id=trans_q

?> **Access**: protected  
**Default**: -  
**Description**: Trans queue to store temporary trans information.  


### `protected yuu_ahb_response_e` response_q[$] :id=response_q

?> **Access**: protected  
**Default**: -  
**Description**: Response queue to store temporary response information.  


### `protected yuu_ahb_exokay_e` exokay_q[$] :id=exokay_q

?> **Access**: protected  
**Default**: -  
**Description**: EXOKAY queue to store temporary exokay information.  


### `protected int unsigned` busy_q[$] :id=busy_q

?> **Access**: protected  
**Default**: -  
**Description**: Busy queue to store temporary busy information.  


### `protected int unsigned` idle_q[$] :id=idle_q

?> **Access**: protected  
**Default**: -  
**Description**: Idle queue to store temporary idle information.  


# Function

## Prototype

| | |
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

| | |
| - | - |
| `task` | [run_phase](#run_phase) |
| `task` | [init_component](#init_component) |
| `task` | [assembling_and_send](#assembling_and_send) |
| `task` | [cmd_phase](#cmd_phase) |
| `task` | [data_phase](#data_phase) |
| `task` | [count_busy](#count_busy) |
| `task` | [count_idle](#count_idle) |
| `task` | [wait_reset](#wait_reset) |

## Function Detailed Documentation

### `task` run_phase (uvm_phase phase) :id=run_phase

?> **Access**: public  
**Description**: UVM built-in method.  


### `task` init_component () :id=init_component

?> **Access**: public  
**Description**: Internal resource initialize.  


### `task` assembling_and_send (yuu_ahb_master_item monitor_item) :id=assembling_and_send

?> **Access**: public  
**Description**: Assemble collected information into transaction and send out monitor.  
Para:  
monitor_item - the item collected by monitor.  


### `task` cmd_phase () :id=cmd_phase

?> **Access**: public  
**Description**: Main monitor task, command phase.  


### `task` data_phase () :id=data_phase

?> **Access**: public  
**Description**: Main monitor task, data phase.  


### `task` count_busy () :id=count_busy

?> **Access**: public  
**Description**: Count busy cycles.  


### `task` count_idle () :id=count_idle

?> **Access**: public  
**Description**: Count idle cycles.  


### `task` wait_reset () :id=wait_reset

?> **Access**: public  
**Description**: Thread of reset waiting for handle on-the-fly reset.  


