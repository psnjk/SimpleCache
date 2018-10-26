# SimpleCache
## Simple cache design implementation in verilog

Completed parts of a project are stored in the "Completed Parts" folder.
Every complete part has comments for all actions, succesfully compiles, and works with other stored modules.

___

Simple Cache implementation shoud have 5 workable modules:
* ram 			            - supporting module which provides data for cache
* ram_tb			          - testbench for ram
* cache			            - simple cache implementation (Direct-mapped cache)
* cache_tb		          - testbench for cache
* demonstrative module  - module to show how other modules perfectly work with each other `optional`

___

### Full descriptions for every module:
#### 1. Ram:
#### 2. Ram Testbench:
#### 3. Direct-mapped cache:
* A cache where the cache location for a given address is determined from the middle address bits. If the cache line size is 2^n then the bottom n address bits correspond to an offset within a cache entry. If the cache can hold 2^m entries then the next m address bits give the cache location. The remaining top address bits are stored as a "tag" along with the entry.
#### 4. Cache Testbench: 
