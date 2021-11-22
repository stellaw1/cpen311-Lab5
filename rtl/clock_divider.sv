module clock_divider
	(input logic in_clk,
	input logic [31:0] div_clk_count,
	output logic out_clk);

	logic [31:0] clk_count = 0;
	always@(posedge in_clk)
	begin
		// check if clk_count has reached the end of the count and reset counter if it has
		if (clk_count >= (div_clk_count - 1))
			clk_count <= 0;
		else
			clk_count <= clk_count + 1;
		// divide desired clock count by 2 to split each period into high and low
		if (clk_count < (div_clk_count / 2))
			out_clk <= 1;
		else
			out_clk <= 0;
	end
endmodule
