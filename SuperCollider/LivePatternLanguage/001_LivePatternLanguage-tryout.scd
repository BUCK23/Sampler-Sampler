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
arg freq = 440, amp = 0.1, atk = 0.01, rel = 0.1, pan = 0;
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
~loopPattern = {
	arg pattern = 0, period = 0.1, num = 1, delay = 0.1, modifier1 = "NONE", modifier2 = "NONE", modifier3 = "NONE", modifier4 = "NONE";
		num.do({~playPattern.(pattern,period);
			((~stitchHistory[pattern].size)*period).wait;
			~processing.sendMsg('/stitchSC',modifier1,modifier2,modifier3,modifier4);
			delay.wait;
		})
};

~keyboardResponder = {
arg freq = 440, amp = 0.5, atk = 0.01, rel = 1, pan = 0;
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

},'/stitchKeyboard');
};


)

/////////////////////////////////////////////////////////////////////////////////
///////////////////LIVE CODING AREA//////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////


~sampleResponder.([500,900],0.01,2,2)

StageLimiter.activate

~keyboardResponder.()


//randomness help
~dirs = ["UP","DOWN","LEFT","RIGHT","UPLEFT","UPRIGHT","DOWNLEFT","DOWNRIGHT"]
~rand = {~dirs.choose}



/*

I CAN NOW SEND FUNCTIONS TO THE INSIDE OF THE OSCDEF.

*/


//basic syntax
//any number of modifiers can be stacked onto this
//pattern, period, repeats, delay, modifiers*4
Tdef(\stitcher, {loop({~loopPattern.(0,0.01,modifier1:~rand.()); ~sampleResponder.([500,900,2000,44100,200,300].choose,0.1,0.01,0.01)}); });

Tdef(\stitcher).play

~rand = {rrand(0.001,0.05)}

~freq = {[400,500,600,700,900,800,1000,2000,9000].choose}

~sampleResponder.(~freq.())

Tdef(\stitcher).play;

~stitchHistory[0]

~savePattern.()


~le = {["LEFT", "UPLEFT","DOWN", "DOWN", "LEFT"].choose;}
~clearScreen.(10)

["LEFT", "UPLEFT","DOWN", "DOWN", "LEFT"!20].flatten

~savePattern.()

~le.()

Tdef(\stitcher).stop

Tdef(\stitcher).play

~processing.sendMsg('/stitchSC',~dirs.choose)


~clearScreen.(32)
~clearPattern.()
~savePattern.()
~loopPattern.(0,0.01,20,0,"DOWNLEFT","DOWN","DOWNLEFT")




////////////////////////////////////////////////////////////////////////////////
////////////////OLD DATA////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

~processing.sendMsg('/stitchSC',"UP")

//pattern experiment
Tdef(\stitcher, { ~clearScreen.(); loop ({ rrand(3,5).do({r = ~rand.(); ~loopPattern.([1,2,3,4].choose,0.07,1,0.1,r,"LEFT"); ~loopPattern.(3,0.05,1,0.1,r)}); ~clearScreen.()}) })


OSCFunc.tracee

~loopPatternTdef = {
	arg pattern = 0, period = 0.1, num = 4, delay = 0.1, modifier = "NONE", modifier2 = "NONE", modifier3 = "NONE", modifier4 = "NONE";
		num.do({~playPattern.(pattern,period);
			((~stitchHistory[pattern].size)*period).wait;
			~processing.sendMsg('/stitchSC',modifier,modifier2,modifier3,modifier4);
			delay.wait;
		})
}

//Change the list number to change iterated
//DOES NOT ADD A NEW SUBLIST!!!
//There is some margin of error in this ~noHistory thing
(
Task({
	arg listNum = 0;
	var data = ~stitchHistory[3];
	~noHistory = 1;
	//iterate over the data as a local variable
	data.size.do({
		|i|
		~processing.sendMsg('/stitchSC',data[i]);
		rrand(0.001,0.005).wait;
	});
	~noHistory = 0;
}).play;
)

//CLEARS SCREEN
~processing.sendMsg('/stitchSC',"CLEAR")


~loopPattern = {
	loop: arg num = 4, delay = 0.1, pattern = 0, period = 0.1, modifier = "NONE", modifier2 = "NONE", modifier3 = "NONE", modifier4 = "NONE";
	Task({
		num.do({~playPattern.(pattern,period);
			((~stitchHistory[pattern].size)*period).wait;
			~processing.sendMsg('/stitchSC',modifier,modifier2,modifier3,modifier4);
			delay.wait;
		})
	}).play;
	loopRev: arg num = 4, delay = 0.1, pattern = 0, period = 0.1, modifier = "NONE", modifier2 = "NONE", modifier3 = "NONE", modifier4 = "NONE";
	Task({
		num.do({~playPattern.(pattern,period);
			((~stitchHistory[pattern].size)*period).wait;
			~processing.sendMsg('/stitchSC',modifier,modifier2,modifier3,modifier4);
			delay.wait;
		})
	}).play;

}



//wrapping the OSCdef in a function, to specify frequency arguments
~sampleResponder = {
arg freq = 440, atk = 0.01, rel = 0.1;
OSCdef(\stitchResponderSampler,
	{
		|msg, time, addr, recvPort, sw, stitch|


		var
		//synthesises different stitching combinations
		up = {arg f = 440; SinOsc.ar(f,0,0.5)},
		down = {arg f = 440; SawDPW.ar(f,0,0.5)},
		left = {arg f = 440, w = 0.5; PulseDPW.ar(f,w,0.5)},
		right = {arg f = 440, w = 0.5; LFTri.ar(f,0,0.5)},
		upleft = {arg f = 440, a = 1, b = 3, c = 0.5, d = 0.5; LatoocarfianN.ar(f,a,b,c,d,0.5,0.5,0.5)},
		upright = {arg f = 440; HenonN.ar(f,mul:0.5)},
		downleft = {arg f = 440; FBSineN.ar(f,mul:0.5)},
		downright = {arg f = 440; GbmanN.ar(f,mul:0.5)};

		//computes stitch type so that it doesn't have to be done multiple times
		stitch = msg[1];

		//switch case to identify the type of stitch that has been pressed
		sw =  switch (msg[1])
		{'UP'} {{up.(q)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
		{'DOWN'} {{down.(q)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
		{'LEFT'} {{left.(q)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
		{'RIGHT'} {{right.(q)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
		{'UPLEFT'} {{upleft.(q)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
		{'UPRIGHT'} {{upright.(q)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
		{'DOWNLEFT'} {{downleft.(q)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play}
		{'DOWNRIGHT'} {{downright.(q)*EnvGen.ar(Env.perc(atk,rel),1,1,0,1,2)}.play};

},'/stitchSampler');
}


