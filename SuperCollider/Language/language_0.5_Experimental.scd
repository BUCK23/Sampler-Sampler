(
~processing = NetAddr.new("127.0.0.1",12000);
//initialises a master list (lists are extendable)
~stitchHistory = List.new;
//initialises the first sub-list, for the stitches to be added
~stitchHistory.add(List.new);
//set value for history to be recorded
// !! THIS MAY NOT BE NEEDED !!
~noHistory = 0;

//this saves the current pattern
~savePattern = {
	~stitchHistory.add(List.new);
	"Pattern ".post;
	(~stitchHistory.size.asInt-2).post;
	" Saved!".postln;
	~stitchHistory[~stitchHistory.size-2];
};


//this clears the current iteration
~clearPattern = {
	"Current pattern cleared! ".postln;
	~stitchHistory[~stitchHistory.size-1].clear;
};

//plays pattern according to specified saved pattern and relevant time delay
// TODO: fix what 'long' does, figure out a good way to handle it - probably with strings
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
			//Modifier in brackets to allow a negative number to be used on patterns
			~processing.sendMsg('/stitchSC',((data[i][0]+(modifier))*multiplier)%7,data[i][1]);
			data[i].postln;
			period.wait;
		});
		~noHistory = 0;
	}).play;
};


//this can be placed inside a Tdef to schedule the looping of patterns
//num cast as an int because IT CRASHES THE SERVER
//Modifications to add more functionality to pattern classes:
// transform = transformation to be applied to the 'number' index of the pattern being played.
// wrapped to the modulo of the number of possible directions
// multiplier multiplies the value by something
// TODO: long 'long-ifies' patterns, but I haven't figured out an appropriate way to deal with that yet. It would need to give a specific signal to overwrite the already existing 'long' value in the pattern dataset.
~loopPattern = {
	arg pattern = 0, period = 0.1, num = 1, delay = 0.1, transform = 0, multiplier = 1, long = 0, modifier1 = "NONE", modifier2 = "NONE", modifier3 = "NONE", modifier4 = "NONE";
	var numReps = 1;
	//this stops the server crashing, casting the number of repetitions as >0
	if ( num < 1 , { numReps = 1 }, { numReps = num.asInt});
	numReps.do({
		//use playPattern function
		~playPattern.(pattern,period,transform, multiplier, long);
		//wait for as long as it takes to play the pattern - this seems inefficient and i should probably just re-write the function with ~playPattern within it, but maybe not.
		((~stitchHistory[pattern].size)*period).wait;
		~processing.sendMsg('/stitchSC',modifier1,modifier2,modifier3,modifier4);
		delay.wait;
	})
};

//clears Processing screen, int specifies grid size
~clearScreen = {arg size = 10; ~processing.sendMsg('/stitchSC',"CLEAR", size); "Screen Cleared!"};

//function to send commands to OSCResponder
//adjusted to handle ints
~sampleResponder = {
	arg freq = 400, amp = 0.1, atk = 0.01, rel = 0.1, pan = 0, envMul = 2;
	OSCdef(\stitchResponderSampler,
		{
			|msg, time, addr, recvPort, sw, stitch|


			var
			//synthesises different stitching combinations
			up = {arg f = 440, amp = 0.1; SinOsc.ar(f,0,amp)},
			down = {arg f = 440, amp = 0.1; SawDPW.ar(f,0,amp)},
			left = {arg f = 440, amp = 0.1, w = 0.5; PulseDPW.ar(f,w,amp)},
			right = {arg f = 440, amp = 0.1, w = 0.5; LFTri.ar(f,0,amp)},
			upleft = {arg f = 440, amp = 0.1, a = 1, b = 3, c = 0.5, d = 0.5; LatoocarfianN.ar(f,a,b,c,d,0.5,0.5,amp)},
			upright = {arg f = 440, amp = 0.1; HenonN.ar(f,mul:amp)},
			downleft = {arg f = 440, amp = 0.1; FBSineN.ar(f,mul:amp)},
			downright = {arg f = 440, amp = 0.1; GbmanN.ar(f,mul:amp)};


			//switch case to identify the type of stitch that has been pressed
			sw =  switch ([msg[1],msg[2]])
			{[0,0]} {{Pan2.ar(up.(freq,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
			{[1,0]} {{Pan2.ar(upright.(freq,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
			{[2,0]} {{Pan2.ar(right.(freq,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
			{[3,0]} {{Pan2.ar(downright.(freq,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
			{[4,0]} {{Pan2.ar(down.(freq,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
			{[5,0]} {{Pan2.ar(downleft.(freq,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
			{[6,0]} {{Pan2.ar(left.(freq,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
			{[7,0]} {{Pan2.ar(upleft.(freq,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
			//TODO: For next version, simplify the way in which these responders function, possibly changing the multiplier option in the function arguments to something more productive
			{[0,1]} {{Pan2.ar(up.(freq,amp),pan)*EnvGen.ar(Env.perc(atk*envMul,rel*envMul),1,1,0,1,2)}.play}
			{[1,1]} {{Pan2.ar(upright.(freq,amp),pan)*EnvGen.ar(Env.perc(atk*envMul,rel*envMul),1,1,0,1,2)}.play}
			{[2,1]} {{Pan2.ar(right.(freq,amp),pan)*EnvGen.ar(Env.perc(atk*envMul,rel*envMul),1,1,0,1,2)}.play}
			{[3,1]} {{Pan2.ar(downright.(freq,amp),pan)*EnvGen.ar(Env.perc(atk*envMul,rel*envMul),1,1,0,1,2)}.play}
			{[4,1]} {{Pan2.ar(down.(freq,amp),pan)*EnvGen.ar(Env.perc(atk*envMul,rel*envMul),1,1,0,1,2)}.play}
			{[5,1]} {{Pan2.ar(downleft.(freq,amp),pan)*EnvGen.ar(Env.perc(atk*envMul,rel*envMul),1,1,0,1,2)}.play}
			{[6,1]} {{Pan2.ar(left.(freq,amp),pan)*EnvGen.ar(Env.perc(atk*envMul,rel*envMul),1,1,0,1,2)}.play}
			{[7,1]} {{Pan2.ar(upleft.(freq,amp),pan)*EnvGen.ar(Env.perc(atk*envMul,rel*envMul),1,1,0,1,2)}.play};

	},'/stitchSampler');
};


//new keyboardResponder using sine waves
//ADJUSTED FOR array&int DIRECTION RESPONSES
~keyboardResponder = {
	arg freq = 100, amp = 0.1, atk = 0.4, rel = 1, pan = 0, envMul = 3;
	OSCdef(\stitchResponderKeyboard,
		{
			|msg, time, addr, recvPort, sw, stitch|


			var
			//synthesises different stitching combinations
			up = {arg f = 100, amp = 0.1; SinOsc.ar(f,0,amp)},
			down = {arg f = 200, amp = 0.1; SinOsc.ar(f,0,amp)},
			left = {arg f = 300, amp = 0.1; SinOsc.ar(f,0,amp)},
			right = {arg f = 400, amp = 0.1; SinOsc.ar(f,0,amp)},
			upleft = {arg f = 500, amp = 0.1; SinOsc.ar(f,0,amp)},
			upright = {arg f = 600, amp = 0.1; SinOsc.ar(f,0,amp)},
			downleft = {arg f = 700, amp = 0.1; SinOsc.ar(f,0,amp)},
			downright = {arg f = 800, amp = 0.1; SinOsc.ar(f,0,amp)};


			//computes stitch type so that it doesn't have to be done multiple times
			stitch = [msg[1],msg[2]].postln;

			//switch case to identify the type of stitch that has been pressed
			sw =  switch ([msg[1],msg[2]])
			{[0,0]} {{Pan2.ar(up.(freq,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
			{[1,0]} {{Pan2.ar(upright.(freq*6,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
			{[2,0]} {{Pan2.ar(right.(freq*4,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
			{[3,0]} {{Pan2.ar(downright.(freq*8,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
			{[4,0]} {{Pan2.ar(down.(freq*2,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
			{[5,0]} {{Pan2.ar(downleft.(freq*7,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
			{[6,0]} {{Pan2.ar(left.(freq*3,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
			{[7,0]} {{Pan2.ar(upleft.(freq*5,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
			//TODO: for next version - simplify the way in which these responders function, possibly changing the multiplier option in the function arguments to something more productive
			{[0,1]} {{Pan2.ar(up.(freq,amp),pan)*EnvGen.ar(Env.perc(atk*envMul,rel*envMul),1,1,0,1,2)}.play}
			{[1,1]} {{Pan2.ar(upright.(freq*6,amp),pan)*EnvGen.ar(Env.perc(atk*envMul,rel*envMul),1,1,0,1,2)}.play}
			{[2,1]} {{Pan2.ar(right.(freq*4,amp),pan)*EnvGen.ar(Env.perc(atk*envMul,rel*envMul),1,1,0,1,2)}.play}
			{[3,1]} {{Pan2.ar(downright.(freq*8,amp),pan)*EnvGen.ar(Env.perc(atk*envMul,rel*envMul),1,1,0,1,2)}.play}
			{[4,1]} {{Pan2.ar(down.(freq*2,amp),pan)*EnvGen.ar(Env.perc(atk*envMul,rel*envMul),1,1,0,1,2)}.play}
			{[5,1]} {{Pan2.ar(downleft.(freq*7,amp),pan)*EnvGen.ar(Env.perc(atk*envMul,rel*envMul),1,1,0,1,2)}.play}
			{[6,1]} {{Pan2.ar(left.(freq*3,amp),pan)*EnvGen.ar(Env.perc(atk*envMul,rel*envMul),1,1,0,1,2)}.play}
			{[7,1]} {{Pan2.ar(upleft.(freq*5,amp),pan)*EnvGen.ar(Env.perc(atk*envMul,rel*envMul),1,1,0,1,2)}.play};

			~stitchHistory[~stitchHistory.size-1].add(stitch);

	},'/stitchKeyboard');
};

~dir = ["UP","DOWN","LEFT","RIGHT","UPLEFT","UPRIGHT","DOWNLEFT","DOWNRIGHT"];
~dirLong = ["UPLONG","DOWNLONG","LEFTLONG","RIGHTLONG","UPLEFTLONG","UPRIGHTLONG","DOWNLEFTLONG","DOWNRIGHTLONG"];
~randDir = {~dir.choose};
~randDirLong = {~dirLong.choose};


~clearSet = {
	arg switch = "OFF", min = 10, max = 10;
	OSCdef(\clearSet,
		{
			if ( switch == "ON",
				{
					~clearScreen.(rrand(min,max).asInt)
			});
		},\screenCleared
	);
};


OSCdef(\hostSavePattern,
	{
		~savePattern.();
	}, '/hostSave'
);

OSCdef(\hostClearPattern,
	{
		~clearPattern.();
	}, '/hostClearArray'
);

~hostPatternControl = {
	OSCdef(\hostSavePattern,
	{
		~savePattern.();
	}, '/hostSave'
);

OSCdef(\hostClearPattern,
	{
		~clearPattern.();
	}, '/hostClearArray'
);
};

)



