module ram_clever(

	input [31:0] address, //address in memory

	input [31:0] data, //data to write
	
	input mode, //1 - write, 0 - read

	input clk, //clock cycle state

	output response, //0 - ram finished writing or reading, 1 - ram busy

	output [31:0] out
);

parameter size = 4096; //size of a ram in bits
//parameter cache_index_size = 6;
//parameter cache_size = 64;

reg [31:0] ram [size - 1:0]; //data matrix for ram

//registers for previous values 
reg [31:0] prev_address;
reg [31:0] prev_data;
reg [31:0] temp_out; //temporary to avoid problems
reg prev_mode;
reg prev_response;

//tag and index for determine which cache block contain address
reg [11 - cache.index_size:0] tag, index;

//initial statement for previous values
initial
begin
	prev_address = 0;
	prev_data = 0;
	prev_response = 0;
	prev_mode = 0;
end

//always works on positive edge, while chache works on negative edge
always @(posedge clk)
	begin
		//
		if ((prev_address != address % size) || (prev_data != data) || (prev_mode != mode))
			begin
				prev_address = address % size;
				prev_data = data;
				prev_mode = mode;
				prev_response = 1;
			end
		else
			if (prev_response)
				begin
					//
					if (mode)
					begin
						ram[prev_address] = data;
						//check if there is current address in cache
						tag = prev_address >> cache.index_size;
						index = prev_address % cache.size;						
						if (cache.valid_array[index] == 1 && cache.tag_array[index] == tag)
							cache.valid_array[index] = 0;
					end
					else
						temp_out = ram[prev_address];
					prev_response = 0;
				end
end


assign out = temp_out;
assign response = prev_response;

endmodule 