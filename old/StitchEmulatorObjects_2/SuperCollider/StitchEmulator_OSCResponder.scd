(
~processing = NetAddr.new("127.0.0.1",12000);
//initialises a master list (lists are extendable)
~stitchHistory = List.new;
//initialises the first sub-list, for the stitches to be added
~stitchHistory.add(List.new);
//set value for history to be recorded
// !! THIS MAY NOT BE NEEDED !!
~noHistory = 0;
OSCdef(\stitchResponder,
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
		sw =  switch (msg[1].postln)
		{'UP'} {{up.(440)*EnvGen.ar(Env.perc,1,1,0,1,2)}.play}
		{'DOWN'} {{down.(440)*EnvGen.ar(Env.perc,1,1,0,1,2)}.play}
		{'LEFT'} {{left.(440)*EnvGen.ar(Env.perc,1,1,0,1,2)}.play}
		{'RIGHT'} {{right.(440)*EnvGen.ar(Env.perc,1,1,0,1,2)}.play}
		{'UPLEFT'} {{upleft.(440)*EnvGen.ar(Env.perc,1,1,0,1,2)}.play}
		{'UPRIGHT'} {{upright.(440)*EnvGen.ar(Env.perc,1,1,0,1,2)}.play}
		{'DOWNLEFT'} {{downleft.(440)*EnvGen.ar(Env.perc,1,1,0,1,2)}.play}
		{'DOWNRIGHT'} {{downright.(440)*EnvGen.ar(Env.perc,1,1,0,1,2)}.play};

		//only record history of stitches if a function is not running
		// !! THIS MAY NOT BE NEEDED !!
		if (~noHistory == 0 , {~stitchHistory[~stitchHistory.size-1].add(stitch)});

},'/stitch');
)

//This saves the current iteration and starts a new one
(
~stitchHistory.add(List.new);
"Pattern ".post;
(~stitchHistory.size.asInt-2).post;
" Saved!".postln;
~stitchHistory[~stitchHistory.size-2];
)


//Change the list number to change iterated
//DOES NOT ADD A NEW SUBLIST!!!
//There is some margin of error in this ~noHistory thing
(
Task({
	arg listNum = 0;
	var data = ~stitchHistory[15];
	~noHistory = 1;
	//iterate over the data as a local variable
	data.size.do({
		|i|
		~processing.sendMsg('/stitchSC',data[i]);
		0.01.wait;
	});
	~noHistory = 0;
}).play;
)







/////////////////////////////////////////OLD IDEAS GO DOWN HERE.


//this sends to the local server, just playing sound
(
Task({
	var data = ~stitchHistory;
	~noHistory = 1;
	//iterate over the data as a local variable
	data.size.do({
		|i|
		NetAddr.localAddr.sendMsg('/stitch',data[i]);
		0.1.wait;
	});
	~noHistory = 0;
	~stitchHistory.add(List.new);
}).start;
)
~stitchHistory[2]

//this sends to Processing, playing both sound and visuals of the latest recorded stitch
//then adds a new sublist to be recorded to
(
Task({
	var data = ~stitchHistory[~stitchHistory.size-1];
	~noHistory = 1;
	//iterate over the data as a local variable
	data.size.do({
		|i|
		~processing.sendMsg('/stitchSC',data[i]);
		0.1.wait;
	});
	~noHistory = 0;
	~stitchHistory.add(List.new);
}).play;
)

