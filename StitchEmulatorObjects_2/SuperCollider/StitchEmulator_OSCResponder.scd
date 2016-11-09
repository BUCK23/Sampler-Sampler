(
~processing = NetAddr.new("127.0.0.1",12000);
~stitchHistory = List.new;
~noHistory = 0;
OSCdef(\stitchResponder,
	{
		|msg, time, addr, recvPort, sw, stitch|

		var
		up = {arg f = 440; SinOsc.ar(f,0,0.5)},
		down = {arg f = 440; SawDPW.ar(f,0,0.5)},
		left = {arg f = 440, w = 0.5; PulseDPW.ar(f,w,0.5)},
		right = {arg f = 440, w = 0.5; LFTri.ar(f,0,0.5)},
		upleft = {arg f = 440, a = 1, b = 3, c = 0.5, d = 0.5; LatoocarfianN.ar(f,a,b,c,d,0.5,0.5,0.5)},
		upright = {arg f = 440; HenonN.ar(f,mul:0.5)},
		downleft = {arg f = 440; FBSineN.ar(f,mul:0.5)},
		downright = {arg f = 440; GbmanN.ar(f,mul:0.5)};

		stitch = msg[1];
		sw =  switch (msg[1].postln)
		{'UP'} {{up.(440)*EnvGen.ar(Env.perc,1,1,0,1,2)}.play}
		{'DOWN'} {{down.(440)*EnvGen.ar(Env.perc,1,1,0,1,2)}.play}
		{'LEFT'} {{left.(440)*EnvGen.ar(Env.perc,1,1,0,1,2)}.play}
		{'RIGHT'} {{right.(440)*EnvGen.ar(Env.perc,1,1,0,1,2)}.play}
		{'UPLEFT'} {{upleft.(440)*EnvGen.ar(Env.perc,1,1,0,1,2)}.play}
		{'UPRIGHT'} {{upright.(440)*EnvGen.ar(Env.perc,1,1,0,1,2)}.play}
		{'DOWNLEFT'} {{downleft.(440)*EnvGen.ar(Env.perc,1,1,0,1,2)}.play}
		{'DOWNRIGHT'} {{downright.(440)*EnvGen.ar(Env.perc,1,1,0,1,2)}.play};

		if (~noHistory == 0 , {~stitchHistory.add(stitch)});

},'/stitch');
)xxzza

//this sends to the local server, just playing sound
(
Task({
	var data = ~stitchHistory;
	~noHistory = 1;
	//iterate over the data as a local variable
	data.size.do({
		|i|
		NetAddr.localAddr.sendMsg('/stitch',data[i]);
		0.02.wait;
	});
	~noHistory = 0;
	~stitchHistory = List.new;
}).start;
)

//this sends to Processing, playing both sound and visuals
(
Task({
	var data = ~stitchHistory;
	~noHistory = 1;
	//iterate over the data as a local variable
	data.size.do({
		|i|
		~processing.sendMsg('/stitchSC',data[i]);
		0.1.wait;
	});
	~noHistory = 0;
	~stitchHistory = List.new;
}).start;
)



~stitchHistory

~processing.sendMsg('/stitchSC',"UP")
