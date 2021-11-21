module lfsr_tb();
	logic clk;
	logic [4:0] lfsr;

	lfsr dut(.clk(clk), .lfsr(lfsr));

	initial begin
		forever begin
			clk = 0;
			#10;
			clk = 1;
			#10;
		end
	end
endmodule