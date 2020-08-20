# Description

AHB slave transaction.  

**Inherits**: ``yuu_ahb_item``

# Constraint

## c_len
**Description**:

Slave transaction only has len=0.  

```verilog
constraint c_len {  
  len==0;  
}  

```

## c_wait
**Description**:

wait_delay range constraint.  

```verilog
constraint c_wait {  
  soft wait_delay inside {[0:`YUU_AHB_MAX_DELAY]};  
  if (!cfg.wait_enable) {  
    wait_delay==0;  
  }  
}  

```
# Properties

## Member List

| prefix | identifier |
| - | - |
| `yuu_ahb_slave_config` | [cfg](#cfg) |
| `rand int unsigned` | [wait_delay](#wait_delay) |

## Properties Detailed Documentation

### `yuu_ahb_slave_config` cfg :id=cfg

?> **Access**: public  
**Default**: -  
**Description**: AHB slave agent configuration object.  


### `rand int unsigned` wait_delay :id=wait_delay

?> **Access**: public  
**Default**: -  
**Description**: HREADY low cycles inside burst transfer.  


# Function

## Prototype

| prefix | identifier |
| - | - |
| `function` | [new](#new) |
| `function void` | [pre_randomize](#pre_randomize) |

## Function Detailed Documentation

### `function` new (string name="yuu_ahb_slave_item") :id=new

?> **Access**: public  
**Description**: Constructor of object.  


### `function void` pre_randomize () :id=pre_randomize

?> **Access**: public  
**Description**: SV built-in function.  


