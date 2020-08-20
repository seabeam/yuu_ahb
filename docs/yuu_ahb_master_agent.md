# Description

Container class for AHB master.  

**Inherits**: ``uvm_agent``

# Properties

## Member List

| prefix | identifier |
| - | - |
| `yuu_ahb_master_config` | [cfg](#cfg) |
| `yuu_ahb_master_sequencer` | [sequencer](#sequencer) |
| `yuu_ahb_master_driver` | [driver](#driver) |
| `yuu_ahb_master_monitor` | [monitor](#monitor) |
| `yuu_ahb_coverage` | [coverage](#coverage) |
| `yuu_ahb_analyzer` | [analyzer](#analyzer) |
| `yuu_ahb_master_adapter` | [adapter](#adapter) |
| `yuu_ahb_master_predictor` | [predictor](#predictor) |
| `uvm_analysis_port #(yuu_ahb_master_item)` | [out_driver_port](#out_driver_port) |
| `uvm_analysis_port #(yuu_ahb_item)` | [out_monitor_port](#out_monitor_port) |

## Properties Detailed Documentation

### `yuu_ahb_master_config` cfg :id=cfg

?> **Access**: public  
**Default**: -  
**Description**: AHB master agent configuration object.  


### `yuu_ahb_master_sequencer` sequencer :id=sequencer

?> **Access**: public  
**Default**: -  
**Description**: AHB master sequencer.  


### `yuu_ahb_master_driver` driver :id=driver

?> **Access**: public  
**Default**: -  
**Description**: AHB master driver.  


### `yuu_ahb_master_monitor` monitor :id=monitor

?> **Access**: public  
**Default**: -  
**Description**: AHB master monitor.  


### `yuu_ahb_coverage` coverage :id=coverage

?> **Access**: public  
**Default**: -  
**Description**: AHB master functional coverage collector.  


### `yuu_ahb_analyzer` analyzer :id=analyzer

?> **Access**: public  
**Default**: -  
**Description**: AHB master throughput analyzer.  


### `yuu_ahb_master_adapter` adapter :id=adapter

?> **Access**: public  
**Default**: -  
**Description**: AHB master register adapter.  


### `yuu_ahb_master_predictor` predictor :id=predictor

?> **Access**: public  
**Default**: -  
**Description**: AHB master register predictor.  


### `uvm_analysis_port #(yuu_ahb_master_item)` out_driver_port :id=out_driver_port

?> **Access**: public  
**Default**: -  
**Description**: Analysis port out from driver.  


### `uvm_analysis_port #(yuu_ahb_item)` out_monitor_port :id=out_monitor_port

?> **Access**: public  
**Default**: -  
**Description**: Analysis port out from monitor after collecting.  


# Function

## Prototype

| prefix | identifier |
| - | - |
| `function` | [new](#new) |
| `function void` | [build_phase](#build_phase) |
| `function void` | [connect_phase](#connect_phase) |
| `function void` | [end_of_elaboration_phase](#end_of_elaboration_phase) |

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


### `function void` end_of_elaboration_phase (uvm_phase phase) :id=end_of_elaboration_phase

?> **Access**: public  
**Description**: UVM built-in method.  


