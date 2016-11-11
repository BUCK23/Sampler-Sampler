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
	"Current pattern cleared! ".post;
	~stitchHistory[~stitchHistory.size-1].clear;
};

//plays pattern according to specified saved pattern and relevant time delay
~playPattern = {
	arg pattern = 0, period = 0.1;
	Task({
		arg listNum = 0;
		var data = ~stitchHistory[pattern];
		~noHistory = 1;
		//iterate over the data as a local variable
		data.size.do({
			|i|
			~processing.sendMsg('/stitchSC',data[i]);
			period.wait;
		});
		~noHistory = 0;
	}).play;
};

//clears Processing screen, int specifies grid size
~clearScreen = {arg size = 10; ~processing.sendMsg('/stitchSC',"CLEAR", size); "Screen Cleared!"};

//function to send commands to OSCResponder
~sampleResponder = {
	arg freq = 400, amp = 0.1, atk = 0.01, rel = 0.1, pan = 0;
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

			//computes stitch type so that it doesn't have to be done multiple times
			stitch = msg[1];

			//switch case to identify the type of stitch that has been pressed
			sw =  switch (msg[1])
			{'UP'} {{Pan2.ar(up.(freq,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
			{'DOWN'} {{Pan2.ar(down.(freq,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
			{'LEFT'} {{Pan2.ar(left.(freq,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
			{'RIGHT'} {{Pan2.ar(right.(freq,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
			{'UPLEFT'} {{Pan2.ar(upleft.(freq,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
			{'UPRIGHT'} {{Pan2.ar(upright.(freq,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
			{'DOWNLEFT'} {{Pan2.ar(downleft.(freq,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
			{'DOWNRIGHT'} {{Pan2.ar(downright.(freq,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play};

	},'/stitchSampler');
};

//this can be placed inside a Tdef to schedule the looping of patterns
//num cast as an int because IT CRASHES THE SERVER
~loopPattern = {
	arg pattern = 0, period = 0.1, num = 1, delay = 0.1, modifier1 = "NONE", modifier2 = "NONE", modifier3 = "NONE", modifier4 = "NONE";
	var numReps = 1;
	//this stops the server crashing, casting the number of repetitions as >0
	if ( num < 1 , { numReps = 1 }, { numReps = num.asInt});
	numReps.do({~playPattern.(pattern,period);
		((~stitchHistory[pattern].size)*period).wait;
		~processing.sendMsg('/stitchSC',modifier1,modifier2,modifier3,modifier4);
		delay.wait;
	})
};

//new keyboardResponder using sine waves
~keyboardResponder = {
	arg freq = 100, amp = 0.1, atk = 0.4, rel = 1, pan = 0;
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
			stitch = msg[1];

			//switch case to identify the type of stitch that has been pressed
			sw =  switch (msg[1])
			{'UP'} {{Pan2.ar(up.(freq,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
			{'DOWN'} {{Pan2.ar(down.(freq*2,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
			{'LEFT'} {{Pan2.ar(left.(freq*3,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
			{'RIGHT'} {{Pan2.ar(right.(freq*4,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
			{'UPLEFT'} {{Pan2.ar(upleft.(freq*5,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
			{'UPRIGHT'} {{Pan2.ar(upright.(freq*6,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
			{'DOWNLEFT'} {{Pan2.ar(downleft.(freq*7,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
			{'DOWNRIGHT'} {{Pan2.ar(downright.(freq*8,amp),pan)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play};

			~stitchHistory[~stitchHistory.size-1].add(stitch);

	},'/stitchKeyboard');
	~dir = ["UP","DOWN","LEFT","RIGHT","UPLEFT","UPRIGHT","DOWNLEFT","DOWNRIGHT"];
	~randDir = {~dir.choose};

};

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

)



