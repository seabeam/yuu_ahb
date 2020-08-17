# Description

Container class for AHB slave.  

**Inherits**: ``uvm_agent``

# Properties

## Member List

| | |
| - | - |
| `yuu_ahb_slave_config` | [cfg](#cfg) |
| `yuu_ahb_slave_sequencer` | [sequencer](#sequencer) |
| `yuu_ahb_slave_driver` | [driver](#driver) |
| `yuu_ahb_slave_monitor` | [monitor](#monitor) |
| `yuu_ahb_coverage` | [coverage](#coverage) |
| `yuu_ahb_analyzer` | [analyzer](#analyzer) |
| `uvm_analysis_port #(yuu_ahb_slave_item)` | [out_driver_port](#out_driver_port) |
| `uvm_analysis_port #(yuu_ahb_item)` | [out_monitor_port](#out_monitor_port) |

## Properties Detailed Documentation

### `yuu_ahb_slave_config` cfg :id=cfg

?> **Access**: public  
**Default**: -  
**Description**: AHB slave agent configuration object.  


### `yuu_ahb_slave_sequencer` sequencer :id=sequencer

?> **Access**: public  
**Default**: -  
**Description**: AHB slave sequencer.  


### `yuu_ahb_slave_driver` driver :id=driver

?> **Access**: public  
**Default**: -  
**Description**: AHB slave driver.  


### `yuu_ahb_slave_monitor` monitor :id=monitor

?> **Access**: public  
**Default**: -  
**Description**: AHB slave monitor.  


### `yuu_ahb_coverage` coverage :id=coverage

?> **Access**: public  
**Default**: -  
**Description**: AHB slave functional coverage collector.  


### `yuu_ahb_analyzer` analyzer :id=analyzer

?> **Access**: public  
**Default**: -  
**Description**: AHB slave throughput analyzer.  


### `uvm_analysis_port #(yuu_ahb_slave_item)` out_driver_port :id=out_driver_port

?> **Access**: public  
**Default**: -  
**Description**: Analysis port out from driver.  


### `uvm_analysis_port #(yuu_ahb_item)` out_monitor_port :id=out_monitor_port

?> **Access**: public  
**Default**: -  
**Description**: Analysis port out from driver.  


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


