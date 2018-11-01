module cache_and_ram_tb(
	input [31:0] address,
	input [31:0] data,
	input clk,
	input mode,
	output response,
	output [31:0] out
);

//previous values
reg [31:0] prev_address, prev_data;
reg prev_mode, prev_response;
reg temp_out;

//registers for ram
reg [31:0] ram_address, ram_data;
reg ram_mode;
wire ram_response;

//registers for cache
reg [31:0] cache_address;
wire [31:0] cache_out;
wire cache_response;

ram ram(
	.address(ram_address),
	.data(ram_data),
	.mode(ram_mode),
	.clk(clk),
	.response(ram_response)
);

cache_no_mode cache(
	.address(cache_address),
	.clk(clk),
	.response(cache_response),
	.out(cache_out)
);

initial
	begin
		prev_address = 0;
		prev_data = 0;
		prev_mode = 0;
	end

//
always @(edge clk)
begin
	//
	if (prev_address != address || prev_data != data || prev_mode != mode)
		begin
			prev_address = address;
			prev_data = data;
			prev_mode = mode;
			prev_response = 1;

			if (prev_mode == 1)
				begin
					ram_address = prev_address;
					ram_data = prev_data;
					ram_mode = 1;
				end
			else
				cache_address = prev_address;
		end	
	else
		if (prev_response && cache_response == 0 && ram_response == 0)
			begin
				temp_out = cache_out;
				prev_response = 0;	
			end
end

assign out = temp_out;
assign response = prev_response;

endmodule 