# YUU UVM AHB Lite VIP

**Documentation**: [https://seabeam.github.io/yuu_ahb](https://seabeam.github.io/yuu_ahb)

Both master and slave are avaliable. 
Example case with 1 master and 1 slave is located in `top.sv` of `sim` folder.

Following is the task list under development:
- [x] Update coverage group in collector
- [ ] Update analyzer
- [x] Add `Abort after error` feature of master
- [x] Support register burst access
- [ ] Add AHB protocal checker
- [ ] Add more AHB4/5 feature
- [x] Add comment
- [x] Add document 

## Note
Submodule `yuu_common` and `yuu_amba` has been included in pkg folder, please run:

git clone https://github.com/seabeam/yuu_ahb.git --recurse-submodules

to clone repo if you haven't done it before;

Or run below command to fulfill the submodule:

git submodule update --init --recursive
