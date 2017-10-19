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
// the most basic version
(
SynthDef(\clickSound,
	{
		arg freq = 440, amp = 0.5, pan = 0, atk = 0.01, dec = 0.3, sus = 0.5, rel = 1, trig = 1;
		var sig, env;
		sig = Saw.ar(freq,amp);
		env = EnvGen.ar(Env.adsr(atk,dec,sus,rel),trig);
		sig = sig * env;
		Out.ar(0,Pan2.ar(sig,pan));
}).add;
)

//slew was added to take out the "clipping" sound
(
SynthDef(\clickSound,
	{
		arg freq1 = 300, freq2 = 400, lpf = 1000, amp = 0.5, pan = 0, atk = 4, dec = 0.3, sus = 0.5, rel = 1, trig = 1;
		var sig, env;
		sig = LPF.ar(Saw.ar(freq1.slew(40,40),1) * SinOsc.ar(freq2.slew(40,40),3).unipolar,lpf.slew(400,400),1);
		env = EnvGen.ar(Env.adsr(atk,dec,sus,rel),trig);
		sig = sig * env;
		Out.ar(0,Pan2.ar(LeakDC.ar(sig),pan,amp * 4));
}).add;
)

x = Synth(\clickSound)

//the second version

//create an array to hold the stitch notes.
//Each instance of a stitch is given a unique number and this will be used to create a synth that can be edited
//this is not the best way to do this and it needs refactoring, but it'll do.
~stitches = Array.newClear(5000)
//this creates a fundamental frequency so that I can do things much faster
~fundamental = 50

OSCFunc.trace

(
(
// this sets up a variable for the synth to access
// the OSCdef controlling how the synth is accessed
OSCdef(\clicked,
	{
		|msg, time, addr, recvPort|
		//this instantiates the synth
		~stitches[msg[1]] = Synth.new(\clickSound);
},'/mousePressed')
);

(
OSCdef(\mouseMoved,
	{
		/*
		message guide
		1 = x movement
		2 = y movement
		3 = gridSize
		4 = trigID

		TODO: This could do with another two messages for start x and start y to set the initial pitch or another characteristic of the synth

		*/
		|msg,time,addr,recvPort|
		//set properties on previously-enabled synths
		// this adds a 'starting frequency' to the frequencies used in the sonification
		//
		~stitches[msg[4]].set(
			//fund * 3 is the starting frequency, with each incrementation on the grid being another multiplication of the fudamental
			// TODO: This doesn't handle negatives, dones this need to be changed?
			// it also comes straight out with zeroes. And i don't know why. This cuts the audio. And i don't know why
			\freq1,((~fundamental*4) + ((msg[1].abs / msg[3] / 2))).postln,
			\freq2,((~fundamental*4) + ((msg[2].abs / msg[3] / 2))).postln,
			\lpf,((msg[1].abs+msg[2].abs) / (msg[3]*2) * (~fundamental*4) + ~fundamental).postln
		);
},'/mousePosition')
);

(
//this takes the number given to the stitch and uses it to terminate the sound once the mouse is released
OSCdef(\released,
	{
		|msg, time, addr, recvPort|
		~stitches[msg[1]].set(\trig,0);
		//this kills the synth
},'/mouseReleased')
)
)

//the second version of the

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
~one = {LPF.ar(Saw.ar([100],0.5) * SinOsc.ar(600,1).unipolar,LFTri.kr(0.1).range(50,3500),1)!2}

~one.play

//with x = Saw.ar and y = SinOsc.ar