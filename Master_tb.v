module Master_tb();
reg clk;
reg start;
reg reset;
reg [1:0] slaveSelect;
reg [7:0] masterDataToSend;
wire [7:0] masterDataReceived;
wire SCLK;
wire [0:2]CS;
wire MOSI;
reg MISO;

integer index;
reg [7:0] slave_memory;
reg [7:0] slave_received_data;

initial begin 
clk=0;
reset=1;
slaveSelect=2'b00;
masterDataToSend[7:0]=8'b01101001;
slave_memory[7:0]=8'b11011010;
slave_received_data = 8'b00000000;
index=0;

#230 
if(masterDataReceived == 8'b11011010)
$display("From Slave To Master: SUCCEEDED");
else
$display("From Slave To Master: FAILED (Expected: %b, Received: %b)", 8'b11011010, masterDataReceived);

if(slave_received_data == 8'b01101001)
$display("From Master To Slave: SUCCEEDED");
else
$display("From Master To Slave: FAILED (Expected: %b, Received: %b)", 8'b01101001, slave_received_data);

#10 $finish;
end

always #10 clk = ~clk;

always @(negedge start) begin
if(index > 2)
//MISO=slave_memory[7];
MISO=slave_memory[0];
end

always @(negedge clk) begin
if (index<9)begin
if (index!=1)begin
start=0;
reset = 0;
index=index+1;
end
else begin
start=1;
index=index+1;
end
end
end

always @(posedge SCLK) begin
MISO=slave_memory[0];//
slave_memory<=slave_memory >> 1;//
end

always @(negedge SCLK) begin
if(index>1 && index<9)begin	//	To avoid first negedge at time=0 && last negedge when SCLK goes back to ZERO
slave_received_data[7] = MOSI;
slave_received_data<=slave_received_data >> 1;
end
end

Master test (clk,reset,start,slaveSelect,masterDataToSend,masterDataReceived,SCLK,CS,MOSI,MISO);
endmodule