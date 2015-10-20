.PHONY: verilog clean test
verilog:
	mkdir -p verilog
	sbt "run --backend v --targetDir verilog"

test:
	mkdir -p simulator
	sbt "run --backend c --targetDir simulator --genHarness --test"

clean:
	rm -r verilog simulator
