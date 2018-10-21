module ram(
	input [31:0] address,
	input [31:0] data,
	input write,
	input clk,
	output response,
	output [31:0] out
);

parameter size = 4096;
reg [31:0] ram [size - 1:0];

reg [31:0] prev_address;
reg [31:0] prev_data;
reg [31:0] prev_out;
reg prev_write;
reg prev_response;

initial 
begin
	prev_address = address % size;
	prev_data = 0;
	prev_response = 0;
	prev_write = 0;
end

always @(posedge clk)
begin
	if ((prev_address != address % size) || (prev_data != data) || (prev_write != write))
	begin
		prev_address = address % size;
		prev_data = data;
		prev_write = write;
		prev_response = 1;
	end
	else
		if (prev_response) 
		begin
			if (write)
				ram[prev_address] = data;
			else
				prev_out = ram[prev_address];
			prev_response = 0;
		end
end

assign out = prev_out;
assign response = prev_response;

endmodule
