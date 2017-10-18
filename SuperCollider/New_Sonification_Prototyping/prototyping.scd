/*

# Sonification Notes:

Data being sent from Processing:

## On click and drag

- The mouse On (trigID) (mousePressed)

- The position of the mouse (X, Y, GridSize, trigID) (mousePosition)

- The mouse off (trigID) (mouseReleased)

- It might also be worth sending a number clicked too so that each click can start an independent note, although maybe not as we're only ging to be clicking once at a time i think.


*/
// click and drag


// this is currently just a sine wave for testing
(
SynthDef(\clickSound,
	{
		arg freq = 440, amp = 0.1, pan = 0, atk = 0.01, dec = 0.3, sus = 0.5, rel = 1, trig = 1;
		var sig, env;
		sig = Saw.ar(freq,amp);
		env = EnvGen.ar(Env.adsr(atk,dec,sus,rel),trig);
		sig = sig * env;
		Out.ar(0,Pan2.ar(sig,pan));
}).add;
)

//create an array to hold the stitch notes.
//Each instance of a stitch is given a unique number and this will be used to create a synth that can be edited
//this is not the best way to do this and it needs refactoring, but it'll do.
~stitches = Array.newClear(5000)

(
// this sets up a variable for the synth to access
// the OSCdef controlling how the synth is accessed
OSCdef(\clicked,
	{
		|msg, time, addr, recvPort|
		//this instantiates the synth
		~stitches[msg[1]] = Synth.new(\clickSound,[\freq,rrand(100,400)]);
		//this kills the synth
		addr.postln;
},'/mousePressed')
)

(
OSCdef(\mouseMoved,
	{
		/*
		message guide
		1 = x movement
		2 = y movement
		3 = gridSize
		4 = trigID
		*/
		|msg,time,addr,recvPort|
		//set properties on previously-enabled synths
		// TODO: This, make a better sonification
		~stitches[msg[4]].set(\freq,msg[1].abs)
},'/mousePosition')
)

(
//this takes the number given to the stitch and uses it to terminate the sound once the mouse is released
OSCdef(\released,
	{
		|msg, time, addr, recvPort|
		//this instantiates the synth
		~stitches[msg[1]].set(\trig,0);
		//this kills the synth
		addr.postln;
},'/mouseReleased')
)

/*

Preliminary testing for sonification

*/

//consider this
p = ProxySpace.push(s)

p.fadeTime = 5

//using multiplying synthesis to create an illusion of space
//beating
~one = {LPF.ar(Saw.ar([100],0.5) * SinOsc.ar(510,1).unipolar,LFTri.kr(0.1).range(50,3500),1)!2}

//no beating
~one = {LPF.ar(Saw.ar([100],0.5) * SinOsc.ar(500,1).unipolar,LFTri.kr(0.1).range(50,3500),1)!2}

//slow beating
~one = {LPF.ar(Saw.ar([100],0.5) * SinOsc.ar(501,1).unipolar,LFTri.kr(0.1).range(50,3500),1)!2}

//very slow beating
~one = {LPF.ar(Saw.ar([100],0.5) * SinOsc.ar(500.01,1).unipolar,LFTri.kr(0.1).range(50,3500),1)!2}

//two tones
~one = {LPF.ar(Saw.ar([100],0.5) * SinOsc.ar(500.01,1).unipolar,LFTri.kr(0.1).range(50,3500),1)!2}

~one.play

//with x = Saw.ar and y = SinOsc.ar