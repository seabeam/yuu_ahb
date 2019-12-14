CASE=uvc_test
ADD=

clean:
	ls | grep -v Makefile | grep -v bench.f | grep -v top.sv | xargs rm -rf
	
comp:
	mkdir -p log
	vcs -sverilog -full64 ${ADD} -lca -kdb -debug_acc+all -f bench.f -q -ntb_opts uvm -timescale=1ns/1ns -l log/compile.log

run:
	simv +UVM_TESTNAME=${CASE} -l log/sim.log ${ADD}&
