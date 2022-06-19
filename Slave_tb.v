module Slave_tb();
reg reset;
reg [7:0] slaveDataToSend;
wire [7:0] slaveDataReceived;
reg SCLK;
reg CS;
reg MOSI;
wire MISO;
reg [7:0] master_memory;
reg [7:0] masterDataToSend;

initial begin
reset=0;
SCLK=0;
CS=0;
master_memory[7:0]=8'b1101_1010;
slaveDataToSend[7:0]=8'b0011_1010;
masterDataToSend[7:0] = master_memory[7:0];
#17

if(master_memory[7:0] == slaveDataToSend[7:0] && masterDataToSend[7:0] == slaveDataReceived[7:0]) $display("Success");
else $display("Failure");

$finish;
end

always begin
#1
SCLK = ~SCLK;
end

always @(posedge SCLK) begin
MOSI = master_memory[0];
master_memory<=master_memory>>1;
end
always @(negedge SCLK) begin
if(MISO == 1  || MISO == 0)
master_memory[7] = MISO;
end

Slave test (reset,slaveDataToSend,slaveDataReceived,SCLK,CS,MOSI,MISO);
endmodule
