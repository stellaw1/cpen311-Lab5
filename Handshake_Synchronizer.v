module Handshake_Synchronizer(clk_in, clk_out, reset, data_in, data_out);
    input [11:0] data_in;
    input clk_in, clk_out, reset;
    output [11:0] data_out;

    logic req_out, ack_out, req_sync, ack_sync;

    Talker_FSM sender (
        .clk(clk_in), 
        .reset(reset), 
        .ack_sync(ack_sync), 
        .req_out(req_out)
    );
    Listener_FSM receiver (
        .clk(clk_out), 
        .reset(reset), 
        .req_sync(req_sync), 
        .ack_out(ack_out)
    );

    //Synchronizer req_sync 
    always @(posedge clk_in, posedge reset) begin
        if (reset)
            req_sync <= 0;
        else 
            req_sync <= req_out;
    end

    //Synchronizer ack_sync
    always @(posedge clk_out, posedge reset) begin
        if (reset)
            ack_sync <= 0;
        else
            ack_sync <= ack_out;
    end

    DFF_Enable #(12) data_reg(
        .D(data_in),
        .clk(clk_out),
        .reset(reset),
        .enable(ack_out),
        .Q(data_out)
    );

endmodule



module Talker_FSM(clk, reset, ack_sync, req_out);
    input clk, reset, ack_sync;
    output req_out;
    
    reg [1:0] state;

    parameter [1:0] IDLE = 2'b00;
    parameter [1:0] S_REQ1 = 2'b01;
    parameter [1:0] S_REQ0 = 2'b10;

    always @(posedge clk, posedge reset) begin
        if (reset) state <= IDLE;
        else begin
            case (state)
                IDLE: state <= S_REQ1;
                S_REQ1:begin
                    if (ack_sync) state <= S_REQ0;
                    else state <= S_REQ1;
                end
                S_REQ0:begin
                    if (~ack_sync) state <= IDLE;
                    else state <= S_REQ0;
                end
                default: state <= IDLE;
            endcase
        end
    end

    always @(*) begin
        req_out = (state == S_REQ1);
    end
endmodule



module Listener_FSM(clk, reset, req_sync, ack_out);
    input clk, reset, req_sync;
    output ack_out;
    
    reg state;

    parameter S_ACK0 = 0;
    parameter S_ACK1 = 1;

    always @(posedge clk, posedge reset) begin
        if (reset) state <= S_ACK1;
        else begin
            case (state)
                S_ACK1: begin
                    if (~req_sync) state <= S_ACK0;
                    else state <= S_ACK1;
                end
                S_ACK0:begin
                    if (req_sync) state <= S_ACK1;
                    else state <= S_ACK0;
                end
                default: state <= S_ACK1;
            endcase
        end
    end

    always @(*) begin
        ack_out = (state == S_ACK1);
    end
endmodule