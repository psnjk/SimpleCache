module (
	input [0:31] address,
	input [0:31] data,
	input write,
	input clk,
	output response,
	output [0:31] out
);

parameter size = 4096;
reg [0:size - 1] ram [0:31];

reg [0:31] prev_adress,
reg [0:31] prev_data,
reg write,
reg prev_response,

