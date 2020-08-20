# Description

AHB register adapter.  

**Inherits**: ``uvm_reg_adapter``

# Properties

## Member List

| prefix | identifier |
| - | - |
| `yuu_ahb_master_config` | [cfg](#cfg) |

## Properties Detailed Documentation

### `yuu_ahb_master_config` cfg :id=cfg

?> **Access**: public  
**Default**: -  
**Description**: AHB agent configuration object.  


# Function

## Prototype

| prefix | identifier |
| - | - |
| `function` | [new](#new) |
| `function uvm_sequence_item` | [reg2bus](#reg2bus) |
| `function void` | [bus2reg](#bus2reg) |

## Function Detailed Documentation

### `function` new (string name="yuu_ahb_master_adapter") :id=new

?> **Access**: public  
**Description**: Constructor of object.  


### `function uvm_sequence_item` reg2bus (const ref uvm_reg_bus_op rw) :id=reg2bus

?> **Access**: public  
**Description**: UVM built-in method. Transfer AHB transaction to pin level information.  


### `function void` bus2reg (uvm_sequence_item bus_item, ref uvm_reg_bus_op rw) :id=bus2reg

?> **Access**: public  
**Description**: UVM built-in method. Transfer pin level information to AHB transaction.  


