module lfsr
(
	input logic clk,
	output logic [4:0] lfsr
);

	reg ff0 = 1'b0;
	reg ff1 = 1'b0;
	reg ff2 = 1'b0;
	reg ff3 = 1'b0;
	reg ff4 = 1'b1;

	logic feedback;
	assign feedback = ff2 ^ ff4;

	always_ff@(posedge clk)
	begin
		ff1 <= ff0;
		ff2 <= ff1;
		ff3 <= ff2;
		ff4 <= ff3;
		ff0 <= feedback;
	end

	assign lfsr = {ff0, ff1, ff2, ff3, ff4};
endmodule