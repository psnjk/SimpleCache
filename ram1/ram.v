module ram(

input [31:0] data, //data to write

input [31:0] addr, //address in memory

input wr, //1 - write, 0 - read

input clk, //clock cycle state

output response, //1 - ram finished writing or reading, 0 - ram busy

output [31:0] out
);

