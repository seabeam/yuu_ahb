# Description

AHB throughput analyzer, which receives transaction out from monitor to process.  
It can be also used for any other process user defined and based on transaction.  

**Inherits**: ``uvm_subscriber #(yuu_ahb_item)``

# Properties

## Member List

| | |
| - | - |
| `yuu_ahb_agent_config` | [cfg](#cfg) |
| `uvm_event_pool` | [events](#events) |
| `protected time` | [m_start_time](#m_start_time) |
| `protected time` | [m_end_time](#m_end_time) |
| `protected boolean` | [m_start](#m_start) |
| `protected int` | [m_count](#m_count) |

## Properties Detailed Documentation

### `yuu_ahb_agent_config` cfg :id=cfg

?> **Access**: public  
**Default**: -  
**Description**: AHB agent configuration object.  


### `uvm_event_pool` events :id=events

?> **Access**: public  
**Default**: -  
**Description**: Global event pool for component communication.  


### `protected time` m_start_time :id=m_start_time

?> **Access**: protected  
**Default**: -  
**Description**: The start time of AHB traffic want to measure on bus.  


### `protected time` m_end_time :id=m_end_time

?> **Access**: protected  
**Default**: -  
**Description**: The end time of AHB traffic want to measure on bus.  


### `protected boolean` m_start :id=m_start

?> **Access**: protected  
**Default**: False  
**Description**: Start flag of analysis, when True indecate that analysis is ongoing.  


### `protected int` m_count :id=m_count

?> **Access**: protected  
**Default**: 0  
**Description**: Transaction count for analysis.  


# Function

## Prototype

| | |
| - | - |
| `function` | [new](#new) |
| `function void` | [connect_phase](#connect_phase) |
| `function void` | [report_phase](#report_phase) |
| `function void` | [write](#write) |

## Function Detailed Documentation

### `function` new (string name, uvm_component parent) :id=new

?> **Access**: public  
**Description**: Constructor of object.  


### `function void` connect_phase (uvm_phase phase) :id=connect_phase

?> **Access**: public  
**Description**: UVM built-in method.  


### `function void` report_phase (uvm_phase phase) :id=report_phase

?> **Access**: public  
**Description**: UVM built-in method.  


### `function void` write (yuu_ahb_item t) :id=write

?> **Access**: public  
**Description**: UVM built-in method. A user implemention of uvm_analysis_imp.  


# Task

## Prototype

| | |
| - | - |
| `task` | [run_phase](#run_phase) |
| `task` | [measure_start](#measure_start) |
| `task` | [measure_end](#measure_end) |

## Function Detailed Documentation

### `task` run_phase (uvm_phase phase) :id=run_phase

?> **Access**: public  
**Description**: UVM built-in method.  


### `task` measure_start () :id=measure_start

?> **Access**: public  
**Description**: Wait measure start event start, record the simulation time and set the start flag.  
Notice the index format of event is:{cfg.get_name()}_analyzer_measure_begin  


### `task` measure_end () :id=measure_end

?> **Access**: public  
**Description**: Wait measure end event start, record the simulation time and clear the start flag.  
Notice the index format of event is:{cfg.get_name()}_analyzer_measure_end  


