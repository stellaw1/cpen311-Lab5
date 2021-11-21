module Fast_to_slow_clock(data_in, clk_fast, clk_slow, reset, data_out);
    input clk_fast, clk_slow, reset;
    input [11:0] data_in;
    output [11:0] data_out;

    logic en, en1_out;
    logic [11:0] r1_out, r3_out;

    Register En1 (.D(clk_slow), .Q(en1_out), .reset(reset), .clk(~clk_fast));
    Register En2 (.D(en1_out), .Q(en), .reset(reset), .clk(~clk_fast));

    Register Reg1 ( .D(data_in), .Q(r1_out), .reset(reset), .clk(clk_fast) );
    DFF_Enable #(12) Reg3 ( .D(r1_out), .Q(r3_out), .reset(reset), .clk(clk_fast), .enable(en) );
    Register Reg2 ( .D(r3_out), .Q(data_out), .reset(reset), .clk(clk_slow) );
endmodule

module Register(D, Q, reset, clk);
    input clk, reset;
    input [11:0] D;
    output [11:0] Q;

    always @(posedge clk, posedge reset) begin
        if (reset)
            Q <= 0;
        else
            Q <= D;
    end
endmodule