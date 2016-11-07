(
x = {arg f = 440; SinOsc.ar(f,0,0.5)};
y = {arg f = 440; SawDPW.ar(f,0,0.5)};
z = {arg f = 440, w = 0.5; PulseDPW.ar(f,w,0.5)};
a = {arg f = 440, w = 0.5; LFTri.ar(f,0,0.5)};
b = {arg f = 440, a = 1, b = 3, c = 0.5, d = 0.5; LatoocarfianN.ar(f,a,b,c,d,0.5,0.5,0.5)};
)

(
OSCdef(\stitchResponder,
	{
		|msg, time, addr, recvPort, sw|

		var up = {arg f = 440; SinOsc.ar(f,0,0.5)},
		down = {arg f = 440; SawDPW.ar(f,0,0.5)},
		left = {arg f = 440, w = 0.5; PulseDPW.ar(f,w,0.5)},
		right = {arg f = 440, w = 0.5; LFTri.ar(f,0,0.5)},
		upleft = {arg f = 440, a = 1, b = 3, c = 0.5, d = 0.5; LatoocarfianN.ar(f,a,b,c,d,0.5,0.5,0.5)},
		upright = {arg f = 440; HenonN.ar(f,mul:0.5)},
		downleft = {arg f = 440; FBSineN.ar(f,mul:0.5)},
		downright = {arg f = 440; GbmanN.ar(f,mul:0.5)};

		sw =  switch (msg[1].postln)
		{'UP'} {{up.(440)*EnvGen.ar(Env.perc,1,1,0,1,2)}.play}
		{'DOWN'} {{down.(440)*EnvGen.ar(Env.perc,1,1,0,1,2)}.play}
		{'LEFT'} {{left.(440)*EnvGen.ar(Env.perc,1,1,0,1,2)}.play}
		{'RIGHT'} {{right.(440)*EnvGen.ar(Env.perc,1,1,0,1,2)}.play}
		{'UPLEFT'} {{upleft.(440)*EnvGen.ar(Env.perc,1,1,0,1,2)}.play}
		{'UPRIGHT'} {{upright.(440)*EnvGen.ar(Env.perc,1,1,0,1,2)}.play}
		{'DOWNLEFT'} {{downleft.(440)*EnvGen.ar(Env.perc,1,1,0,1,2)}.play}
		{'DOWNRIGHT'} {{downright.(440)*EnvGen.ar(Env.perc,1,1,0,1,2)}.play};

},'/stitch');
)
