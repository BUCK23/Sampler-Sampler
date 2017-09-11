//create new list
~numL = List.new
//add list with random numbers in it
(
~numL.add(List.new);

~numL[~numL.size-1].add(rrand(1,1000));
~numL
)
//remove final element of list if list is greater than 1, if list is exactly 1, just clear it so that we don't run into problems later on with overflows and suchlike
(
if ( ~numL.size > 1,
	{
		~numL.removeAt(~numL.size-1);
		~numL;
	},
	{
		~numL[0] = List.new;
	}
)
)

~numL

~numL[0].add(rrand(4000,39932993))

// add this into the code