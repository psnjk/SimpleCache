

# Simple direct-mapped cache simulation on FPGA
------
The subject of this article is the topic of the project for first year bachelors, the purpose of which is to show an understanding of the topic, or to help to understand it using simulation. 
___

Principle of work but from the user side should look like:
* To write any data in memory, you need to access the RAM with data and address in which we want to write.
* To access the data, we have to adress to cache. If the cache cannot find the necessary data, then it accesses the RAM by copying data from there.

When working with Verilog, it should be understood that each individual block of the program is represented as a module. As you know, the cache is not an independent part of fast memory, and for its proper operation it needs to take data from another memory block - RAM. Therefore, in order to simulate the work of the cache at the FPGA, we have to simulate whole RAM module which includes cache as well, but the main point is cache simulation. 

The implementation consists of such modules:
* ram.v - RAM memory module
* cache.v - Cache memory module
* cache_and_ram.v - module that operates with data and memory.

<cut/>

### RAM module:
<spoiler title="Code">
```verilog
module ram();

parameter size = 4096; //size of a ram in bits

reg [31:0] ram [0:size-1]; //data matrix for ram

endmodule
```
</spoiler>

<spoiler title="Description">
Module represents memory which is used as RAM. It has 4096 32-bit addressable cells to store some data. 
</spoiler>

<img src="https://habrastorage.org/webt/03/an/bx/03anbxhid6b_h5kyzrz5ia6dzzc.png" />
---

###Cache module:
<spoiler title="Code">
```verilog
module cache();

parameter size = 64;		// cache size
parameter index_size = 6;	// index size


reg [31:0] cache [0:size - 1]; //registers for the data in cache
reg [11 - index_size:0] tag_array [0:size - 1]; // for all tags in cache
reg valid_array [0:size - 1]; //0 - there is no data 1 - there is data

initial
	begin: initialization
		integer i;
		for (i = 0; i < size; i = i + 1)
		begin
			valid_array[i] = 6'b000000;
			tag_array[i] = 6'b000000;
		end
	end

endmodule 
```
</spoiler>
<spoiler title="Description">
So the cache contains more than just copies of the data in
memory; it also has bits to help us find data within the cache and
verify its validity.
</spoiler>
<img src="https://habrastorage.org/webt/oy/xg/gw/oyxggwb5ikbgmkyn3mycpj1ft-y.png" />
---

###Cache and RAM module:
<spoiler title="Code">
```verilog
module cache_and_ram(
	input [31:0] address,
	input [31:0] data,
	input clk,
	input mode,
	output [31:0] out
);

//previous values
reg [31:0] prev_address, prev_data;
reg prev_mode;
reg [31:0] temp_out;

reg [cache.index_size - 1:0] index;	// for keeping index of current address
reg [11 - cache.index_size:0] tag;	// for keeping tag of ceurrent address

ram ram();
cache cache();

initial
	begin
		index = 0;
		tag = 0;
		prev_address = 0;
		prev_data = 0;
		prev_mode = 0;
	end

always @(edge clk)
begin
	//check if the new input is updated
	if (prev_address != address || prev_data != data || prev_mode != mode)
		begin
			prev_address = address % ram.size;
			prev_data = data;
			prev_mode = mode;
			
			tag = prev_address >> cache.index_size;	// tag = first bits of address except index ones (In our particular case - 6)
			index = address % cache.size; 		// index value = last n (n = size of cache) bits of address
				
			if (mode == 1)
				begin
					ram.ram[prev_address] = data;
					//write new data to the relevant cache block if there is such one
					if (cache.valid_array[index] == 1 && cache.tag_array[index] == tag)
						cache.cache[index] = data;
				end
			else
				begin
					//write new data to the relevant cache's block, because the one we addressing to will be possibly addressed one more time soon
					if (cache.valid_array[index] != 1 || cache.tag_array[index] != tag)
						begin
							cache.valid_array[index] = 1;
							cache.tag_array[index] = tag;
							cache.cache[index] = ram.ram[prev_address];
						end
					temp_out = cache.cache[index];
				end	
		end
end

assign out = temp_out;

endmodule 
```
</spoiler>

