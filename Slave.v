module Slave (
	input wire reset,
	input reg [7:0] slaveDataToSend,
	output reg [7:0] slaveDataReceived,
	input wire SCLK,
	input wire CS,
	input wire MOSI,
	output reg MISO);


integer index = 0;
reg flag = 0;
initial begin
MISO = 1'bz;
end

//assign MISO =(CS == 0)? dummy:MISO;

always @(slaveDataToSend or CS==1)
    index = 0;

always @ (posedge reset) begin
slaveDataReceived<=0;
index = 0;
end

always @ (posedge SCLK) begin
if(CS==0) begin
index = index +1;
if(index < 9) begin
//MISO = slaveDataToSend[8-index];
MISO = slaveDataToSend[index-1];//
flag = 1;
end
end//
else
MISO = 1'bz;
//end
end

always @ (negedge SCLK && index < 9 && flag) begin
if(CS==0) begin
slaveDataReceived[7:0]<={MOSI,slaveDataReceived[7:1]};
end
end


endmodule
