module Master(
    input clk,
    input reset,
    input start,
    input [1:0] slaveSelect,
    input [7:0] masterDataToSend,
    output reg [7:0] masterDataReceived,
    output SCLK,
    output reg [0:2] CS,
    output reg MOSI,
    input wire MISO
);

reg [3:0] count;
reg [7:0] data;
reg enable;
assign SCLK = clk & enable;


initial begin
    count = 4'd0;
    enable = 0;
    CS = 3'b111;
end

always @(posedge reset) begin
    count = 4'd0;
    enable = 0;
    CS = 3'b111;
    data = masterDataToSend;
    MOSI = data[0];
end

always @(posedge count[3])
    enable = 0;

always @(posedge start) begin
    #1 if(reset == 0) begin
        data = masterDataToSend;
        masterDataReceived = 8'b00000000;
        count = 4'd0;
        CS = 3'b111;
        if(slaveSelect == 0) begin
            CS[0] = 0;
        end else begin if (slaveSelect == 1) begin
            CS[1] = 0;
          end else begin
            CS[2] = 0;
          end
        end
        MOSI = data[0];
    end
    enable = 1;
end

//  SAMPLING && SHIFTING
always @(negedge SCLK) begin
    if(reset == 0 && enable == 1) begin
        masterDataReceived = masterDataReceived >> 1;
        masterDataReceived[7] = MISO;
        #8		//  Shifting happens right before the positive edge (after the negative edge)
        data = data >> 1;
        count <= count + 1'b1;
        if(count != 7)
            MOSI = data[0];
    end
end

endmodule