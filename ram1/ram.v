module ram(

input [31:0] address, //address in memory

input [31:0] data, //data to write

input write, //1 - write, 0 - read

input clk, //clock cycle state

output response, //1 - ram finished writing or reading, 0 - ram busy

output [31:0] out
);

parameter size = 4096; //size of a ram in bits

reg [31:0] ram [size - 1:0] //data matrix for ram

//registers for previous values 
reg [31:0] prev_address;
reg [31:0] prev_data;
reg [31:0] temp_out; //temporary to avoid problems
reg prev_write;
reg prev_response;

initial //initial statement for previous values
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
						temp_out = ram[prev_address];
					prev_response = 0;
		end
end


assign out = temp_out;
assign response = prev_response;

endmodule
