# Description

AHB slave driver callback library.  

**Inherits**: ``uvm_callback``

# Function

## Prototype

| prefix | identifier |
| - | - |
| `function` | [new](#new) |

## Function Detailed Documentation

### `function` new (string name="yuu_ahb_slave_driver_callback") :id=new

?> **Access**: public  
**Description**: Constructor of object.  


# Task

## Prototype

| prefix | identifier |
| - | - |
| `virtual task` | [pre_send](#pre_send) |
| `virtual task` | [post_send](#post_send) |

## Function Detailed Documentation

### `virtual task` pre_send (yuu_ahb_slave_driver driver, yuu_ahb_slave_item item) :id=pre_send

?> **Access**: public  
**Description**: Callback task before send transaction to bus.  


### `virtual task` post_send (yuu_ahb_slave_driver driver, yuu_ahb_slave_item item) :id=post_send

?> **Access**: public  
**Description**: Callback task after send transaction to bus.  


