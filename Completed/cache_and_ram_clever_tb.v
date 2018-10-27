module cache_and_ram_clever_tb(
	input [31:0] address,
	input [31:0] data,
	input clk,
	input mode,
	output [31:0] out
);

//previous values
reg [31:0] prev_address, prev_data;
reg prev_mode;

//registers for ram
reg [31:0] ram_address, ram_data;
reg ram_mode;
//wire [31:0] ram_out;
wire ram_response;

//registers for cache
reg [31:0] cache_address;
wire [31:0] cache_out;
wire cache_response;

ram_clever ram(
	.address(ram_address),
	.data(ram_data),
	.mode(ram_mode),
	.clk(clk),
	.response(ram_response)
	//.out(ram_out)
);

cache_no_mode_clever cache(
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
		end	
	else
		begin
			// 
			if (mode && !ram_response)
				begin
					ram_address = address;
					ram_data = data;
					ram_mode = mode;
				end
			//
			if (!mode && !cache_response)
				cache_address = address;
		end
end

assign out = cache_out;

endmodule 