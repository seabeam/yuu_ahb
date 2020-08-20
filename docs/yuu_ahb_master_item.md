# Description

AHB master transaction.  

**Inherits**: ``yuu_ahb_item``

# Constraint

## c_idle
**Description**:

idle_delay range constraint.  

```verilog
constraint c_idle {  
  soft idle_delay inside {[0:`YUU_AHB_MAX_DELAY]};  
  if (!cfg.idle_enable) {  
    idle_delay==0;  
  }  
}  

```

## c_busy
**Description**:

busy_delay range constraint.  

```verilog
constraint c_busy {  
  busy_delay.size()==len+1;  
  foreach (busy_delay[i]) {  
    soft busy_delay[i] inside {[0:`YUU_AHB_MAX_DELAY]};  
    if (!cfg.busy_enable || len==0) {  
      busy_delay[i]==0;  
    }  
  }  
}  

```
# Properties

## Member List

| prefix | identifier |
| - | - |
| `yuu_ahb_master_config` | [cfg](#cfg) |
| `rand int unsigned` | [idle_delay](#idle_delay) |
| `rand int unsigned` | [busy_delay[]](#busy_delay) |

## Properties Detailed Documentation

### `yuu_ahb_master_config` cfg :id=cfg

?> **Access**: public  
**Default**: -  
**Description**: AHB master agent configuration object.  


### `rand int unsigned` idle_delay :id=idle_delay

?> **Access**: public  
**Default**: -  
**Description**: Idle cycles between transactions.  


### `rand int unsigned` busy_delay[] :id=busy_delay

?> **Access**: public  
**Default**: -  
**Description**: Busy hold cycles inside burst transfer.  


# Function

## Prototype

| prefix | identifier |
| - | - |
| `function` | [new](#new) |
| `function void` | [pre_randomize](#pre_randomize) |
| `function void` | [command_process](#command_process) |
| `function void` | [data_process](#data_process) |

## Function Detailed Documentation

### `function` new (string name="yuu_ahb_master_item") :id=new

?> **Access**: public  
**Description**: Constructor of object.  


### `function void` pre_randomize () :id=pre_randomize

?> **Access**: public  
**Description**: SV built-in function.  


### `function void` command_process () :id=command_process

?> **Access**: public  
**Description**: Process AHB command information.  


### `function void` data_process () :id=data_process

?> **Access**: public  
**Description**: Process AHB data information.  


