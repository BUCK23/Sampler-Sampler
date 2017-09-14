(
~logging = 0;
~stitchHistory = List.new;
~processing = NetAddr.new("127.0.0.1",12000);
)

// Receives a dump of stitch information
(
OSCdef(\makeStitchArray,
	{
		|msg, time, addr, recvPort, sw, stitch|

		if ( ~logging != 0 , {
			//dump the contents of the message to an array inside the ~stitchHistory list
			~stitchHistory[~stitchHistory.size-1].add([msg[1],msg[2],msg[3],msg[4],msg[5]])
		})
},'/stitchInfo')
)

(
OSCdef(\stitchListener,
	{
		|msg, time, addr, recvPort, sw, stitch|

		if (msg[1] == 1,
			{
				//make a new list for things to be dumped to
				~stitchHistory.add(List.new);
				//start data logging by flipping this
				~logging = 1;
				"logging data".postln;
			},
			{
				~logging = 0;
				//if the array ended up being empty after information has been dumped to it, snip it from the array because it's just going to bog down the installation and it's an easy spam trap if someone just mashes the buttons
				if ( ~stitchHistory[~stitchHistory.size-1].size == 0 ,
					{ ~stitchHistory.removeAt(~stitchHistory.size-1);
						"empty index removed".postln;
					}
				);
				//append an extra integer to the end message, so that Processing knows to log the final x/y values
				~stitchHistory[~stitchHistory.size-1][~stitchHistory[~stitchHistory.size-1].size-1].add(0)
				"no longer logging data".postln;
		})
},'/stitchListener')
)

(
~playPattern = {
	arg pattern = 0, period = 0.1, modifier = 0, multiplier = 1, long = 0;
	Task({
		arg listNum = 0;
		var data;
		data = ~stitchHistory[pattern];
		//iterate over the data as a local variable
		data.size.do({
			|i|
			//adjusted to send two values to Processing - I think, the first 0 just queries the list.
			//Modifier in brackets to allow a negative number to be used on patterns - REMOVED TO SIMPLIFY FOR NOW.
			//For the purposes of the installation the modifiers might not be necessary.
			//the size is sent to determine whether or not the packet sent is the 'final' packet!
			if(data[i].size == 5, {
				~processing.sendMsg('/stitchSC',data[i][0],data[i][1],data[i][2],data[i][3],data[i][4]);
			},
			//if this is made more complex, an else statement could be used here.
			{
				"final packet sent!".postln;
				~processing.sendMsg('/stitchSC',data[i][0],data[i][1],data[i][2],data[i][3],data[i][4],data[i][5]);
			});
			//data[i].postln;
			period.wait;
		});
		~noHistory = 0;
	}).play;
};
)

~stitchHistory[~stitchHistory.size-1][~stitchHistory[~stitchHistory.size-1].size-1].size

(
~loopPattern = {
	arg pattern = 0, period = 0.1, num = 1, delay = 0.1, transform = 0, multiplier = 1, long = 0, dir1 = "NONE", len1 = "NONE", dir2 = "NONE", len2 = "NONE";
	var numReps = 1;
	//this stops the server crashing, casting the number of repetitions as >0
	if ( num < 1 , { numReps = 1 }, { numReps = num.asInt});
	numReps.do({
		//use playPattern function
		//"Playing Pattern ".post;
		//pattern.post;
		~playPattern.(pattern,period,transform, multiplier, long);
		//wait for as long as it takes to play the pattern - this seems inefficient and i should probably just re-write the function with ~playPattern within it, but maybe not.
		((~stitchHistory[pattern].size)*period).wait;
		//send the modifiers
		~processing.sendMsg('/stitchSC',dir1,len1);
		~processing.sendMsg('/stitchSC',dir2,len2);
		delay.wait;
	})
};
)