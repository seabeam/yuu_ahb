clean:
	@rm .[a-zA-Z0-9]* -rf
	@ls -A | grep -v Makefile | xargs rm -rf
	@echo clean done
	
comp:
	@mkdir -p log
	vcs -sverilog -full64 ${ADD} -debug_acc+all \
			-q -ntb_opts uvm -lca -kdb \
			-f ../list/bench.lst \
			+define+YUU_UVM \
			-l log/compile.log

comp_single:
	@mkdir -p log
	vcs -sverilog -full64 ${ADD} -debug_acc+all \
			-q -ntb_opts uvm -lca -kdb \
			-f ../list/single_bench.lst \
			+define+YUU_UVM \
			-l log/compile.log

case:
	@ls ../case | grep _case | cut -d "." -f 1

run:
	./simv +UVM_TESTNAME=${CASE} -l log/sim.log ${ADD}
