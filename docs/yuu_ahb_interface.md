# Description

AHB bus interface. It is a wrapper of AHB masters and slaves.  


# Function

## Prototype

| | |
| - | - |
| `function void` | [check_master_define](#check_master_define) |
| `function void` | [check_slave_define](#check_slave_define) |
| `function virtual yuu_ahb_master_interface` | [get_master_if](#get_master_if) |
| `function virtual yuu_ahb_slave_interface` | [get_slave_if](#get_slave_if) |

## Function Detailed Documentation

### `function void` check_master_define (int idx) :id=check_master_define

?> **Access**: public  
**Description**: Check the index exceeds the maximum master number.  
Para:  
idx - The master index.  


### `function void` check_slave_define (int idx) :id=check_slave_define

?> **Access**: public  
**Description**: Check the index exceeds the maximum slave number.  
Para:  
idx - The slave index.  


### `function virtual yuu_ahb_master_interface` get_master_if (int idx) :id=get_master_if

?> **Access**: public  
**Description**: Get master interface from binding.  
Para:  
idx - The master index.  


### `function virtual yuu_ahb_slave_interface` get_slave_if (int idx) :id=get_slave_if

?> **Access**: public  
**Description**: Get slave interface from binding.  
Para:  
idx - The slave index.  


