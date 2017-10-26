/*

# Sonification Notes:

Data being sent from Processing:

## On click and drag

- The mouse On (trigID) (Xlen, Ylen, GridSize, trigID, initX, initY)

- The position of the mouse (Xlen, Ylen, GridSize, trigID, initX, initY) (mousePosition)

- The mouse off (trigID) (mouseReleased)

- It might also be worth sending a number clicked too so that each click can start an independent note, although maybe not as we're only ging to be clicking once at a time i think.

- So this uses multiplications of a fundamental frequency across two multiplied oscillators based on the grid system. This needs to be written up

*/
// click and drag

(
("../Language/language_1.9_Installation.scd").loadRelative;
~keyboardResponder.();
~sampleResponder.();
~hostPatternControl.();
)

//recall stitches
~stitchHistory = File("~/src/github/Sampler-Sampler/SuperCollider/savedStitches/stitches_install.txt".standardizePath,"r").readAllString.interpret


//stitch Tdef
(
Tdef(\stitch,
	{ loop ({
		~loopPattern.(
			pattern:rrand(0,~stitchHistory.size-1),
			period:0.1,
			num:1,
			delay:1,
			transform:0,
			multiplier:1,
		);
	})}
)
)

Tdef(\stitch).play


OSCFunc.trace(false)

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
		sig = LPF.ar(Saw.ar(freq1.slew(4000,4000),1) * SinOsc.ar(freq2.slew(4000,4000),3).unipolar,lpf.slew(4000,4000),1);
		env = EnvGen.ar(Env.adsr(atk,dec,sus,rel),trig);
		sig = sig * env;
		Out.ar(0,Pan2.ar(LeakDC.ar(sig),pan,amp * 4));
}).add;
)


//the second version

//create an array to hold the stitch notes.
//Each instance of a stitch is given a unique number and this will be used to create a synth that can be edited
//this is not the best way to do this and it needs refactoring, but it'll do.
~stitches = Array.newClear(5000)
//this creates a fundamental frequency so that I can do things much faster
~fundamental = 50

/*

//This is a functioning prototype for sonifiying touch screen data - 10:26 19/10/17


*/
(
~fundamental = 50;
~stitches = Array.newClear(5000);


(
// this sets up a variable for the synth to access
// the OSCdef controlling how the synth is accessed
OSCdef(\clicked,
	{
		|msg, time, addr, recvPort|
		//this instantiates the synth
		~stitches[msg[4]] = Synth.new(\clickSound,[
			\freq1,((~fundamental*4) + ((msg[1].abs / msg[3] / 2)) + ((msg[5] / msg[3]) * (~fundamental/ 10))),
			\freq2,((~fundamental*4) + ((msg[2].abs / msg[3] / 2)) + ((msg[6] / msg[3]) * (~fundamental/ 10))),
			\lpf,((msg[1].abs+msg[2].abs) / (msg[3]*2) * (~fundamental*4) + ~fundamental)]);
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
		5 = StartX
		6 = StartY

		TODO: This could do with another two messages for start x and start y to set the initial pitch or another initial characteristic of the synth, so that the stitches appear to 'do' something rather than just being the same note each time on a different part of the canvas

		*/
		|msg,time,addr,recvPort|
		//set properties on previously-enabled synths
		// this adds a 'starting frequency' to the frequencies used in the sonification
		//
		~stitches[msg[4]].set(
			//fund * 3 is the starting frequency, with each incrementation on the grid being another multiplication of the fudamental
			// TODO: This doesn't handle negatives, dones this need to be changed?
			//TODO: tune this for a touch screen
			\freq1,((~fundamental*4) + ((msg[1].abs / msg[3] / 2)) + ((msg[5] / msg[3]) * (~fundamental/ 10))),
			\freq2,((~fundamental*4) + ((msg[2].abs / msg[3] / 2)) + ((msg[6] / msg[3]) * (~fundamental/ 10))),
			\lpf,((msg[1].abs+msg[2].abs) / (msg[3]*2) * (~fundamental*4) + ~fundamental)
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


//sonification of patterns
// a basic sonification engine
/*

A few things will need to be done here:

- A sonification over two dimensions will need to be developed. This can't be like the old sonification where the form of the sonification is based on discrete direction data. Rather, a progression of X/Y co-ordinates will need to be used
- The sonification will need to vary across the canvas. This will have to be accomplished using feedback from Processing

Messages about sampled stitches are received in a very similar way to messages about drawn stitches

Xlen, Ylen, gridSize, ID, newX, newY

example:

[ /sampledStitchInfo, -1, -7, 40, 0, 40, 22 ]


TODO: There is an issue with the new data format that I chose, in that some stuff is getting dropped when it hits processing side due to it not being recognised. I need to figure out what this is.

*/

(
SynthDef(\stitchSonifier,
	{
		arg freq = 440, amp = 0.5, atk = 0.01, dec = 0.3, sus = 0.5, rel = 1, trig = 1, pan = 0, curve = \exp;
		var sig,env;
		sig = SinOsc.ar(freq,0,amp);
		env = EnvGen.ar(Env.linen(atk,sus,rel,1),trig,doneAction:2);
		sig = sig * env;
		Out.ar(0,Pan2.ar(sig,pan));
	}
).add;

(
OSCdef(\stitchResponder,
	{
		|msg, time, addr, recvPort|
		Synth(\stitchSonifier,[\rel,0.1,\sus,0.1]);
		msg.postln;
	},'/stitchSC')
)
)



/*

Preliminary testing for sonification of touch

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

//Prototyping the emulator sampled stitching playback

//this is the clickSound SynthDef, but with a different envelope structure (linen rather than adsr)
(
SynthDef(\sampleSound,
	{
		arg freq1 = 300, freq2 = 400, lpf = 1000, amp = 0.5, pan = 0, atk = 0.01, dec = 0.1, sus = 0.1, rel = 0.4, trig = 1;
		var sig, env;
		sig = LPF.ar(Saw.ar(freq1.slew(4000,4000),1) * SinOsc.ar(freq2.slew(4000,4000),3).unipolar,lpf.slew(4000,4000),1);
		env = EnvGen.ar(Env.linen(atk,sus,rel),trig,doneAction:2);
		sig = sig * env;
		Out.ar(0,Pan2.ar(LeakDC.ar(sig),pan,amp * 4));
}).add;
);

OSCFunc.trace
Tdef(\stitch).play

// this is a simple sonification that uses the length of the stitch to open up a low pass filter, and uses
(
OSCdef(\sampleReceiver,
	{
		|msg|
		Synth(\sampleSound,[
			\freq1,(~fundamental + ((msg[5] + (msg[1])) * (~fundamental / 2))).post,
			"       ".post;
			\freq2,(~fundamental + ((msg[6] + (msg[2])) * (~fundamental / 2))).postln,
			\lpf, (~fundamental + ((msg[1].abs + msg[2].abs) * (~fundamental * 3)))
		]
		)
},'/sampledStitchInfo')
);



// So the original mouseclick sound uses the X and Y position to adjust the frequency of freq1 & freq2, and the length of the stitch to adjust the level of the LPF
Synth(\sampleSound)