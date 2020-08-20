# Description

AHB slave monitor callback library.  

**Inherits**: ``uvm_callback``

# Function

## Prototype

| prefix | identifier |
| - | - |
| `function` | [new](#new) |

## Function Detailed Documentation

### `function` new (string name="yuu_ahb_slave_monitor_callback") :id=new

?> **Access**: public  
**Description**: Constructor of object.  


# Task

## Prototype

| prefix | identifier |
| - | - |
| `virtual task` | [pre_collect](#pre_collect) |
| `virtual task` | [post_collect](#post_collect) |

## Function Detailed Documentation

### `virtual task` pre_collect (yuu_ahb_slave_monitor monitor, yuu_ahb_slave_item item) :id=pre_collect

?> **Access**: public  
**Description**: Callback task before collect transaction on bus.  


### `virtual task` post_collect (yuu_ahb_slave_monitor monitor, yuu_ahb_slave_item item) :id=post_collect

?> **Access**: public  
**Description**: Callback task after collect transaction on bus.  


