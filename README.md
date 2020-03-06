# yuu_ahb
UVM AHB Lite VIP

Both master and slave are avaliable. 
Example case with 1 master and 1 slave is located in `top.sv` of `sim` folder.

Following is the task list under development:
- [ ] Update coverage group in collector
- [ ] Update analyzer
- [ ] Add `Abort after error` feature of master
- [x] Support register burst access
- [ ] Add AHB protocal checker
- [ ] Add more AHB4/5 feature

## Note
[yuu_common](https://github.com/seabeam/yuu_common "YUU UVM utilities package") package is needed  
[yuu_amba](https://github.com/seabeam/yuu_amba "YUU UVM AMBA base package") package is needed