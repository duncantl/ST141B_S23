
+ funs0.R 
   + start from the code we interactively developed when exploring how to read a tab le.
   + functions here are useful for reading a specific table, assuming we have already computed the text for that table.
   + assumptions about columnStarts
   + misuse of columnStarts in second call to read.fwf
   + ) in wrong place in sort()
   
+ funs1.R
   + fixes the read.fwf() call to compute the widths, not the column starting positions
   + fixes error in the sort() - parenthesis in the wrong place 

+ funs2.R
   + new high-level functions to process the file, get both/all tables
   + convert the 7th column (%) to numeric values
   + comments on functions and code

+ funs3.R
   + extend funs2.R to combine 2 lines of header to get column names.
   + errors/bugs.

+ funs4.R 
   + better
