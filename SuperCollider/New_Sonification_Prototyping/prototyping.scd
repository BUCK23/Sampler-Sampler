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

//4th October: load new lang
("../Language/language_1.9_1_Installation.scd").loadRelative;

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

// this is a simple sonification that uses the length of the stitch to open up a low pass filter, and uses the position of the stitches to control the frequency of the two waves

// example: [ /sampledStitchInfo, -1, -7, 40, 0, 40, 22 ]

// a fundamental issue in this system is that the grid lines are not zeroed.
// what I want is for the frequencies to get more dissonant the further out they are from the center?
// So each stitch sounds similar, or is 'a sample', but the content of the sample changes

~fundamental + ((-4 + 12) * (~fundamental))

//original as of 2nd November
(
OSCdef(\sampleReceiver,
	{
		|msg|
		Synth(\sampleSound,[
			\freq1,(~fundamental + ((msg[5] + (msg[1])) * (~fundamental / 2))),
			\freq2,(~fundamental + ((msg[6] + (msg[2])) * (~fundamental / 2))),
			\lpf, (~fundamental + ((msg[1].abs + msg[2].abs) * (~fundamental * 3)))
		]
		);
		("message1 = "+msg[1]).post;
		("  message2 = "+msg[2]).postln;
},'/sampledStitchInfo')
);


//Maybe modify it using MIDI notes, it's a bit of a brutal sell, but it could work?
/*

NOTES 2nd November 2017

The parameters we need to account for:

X and Y Position and Length to be reflected in frequency
Length of stitch to be reflected in envelope length
Overall position to be reflected in the LPF?

Maybe reperesent it using two oscillators?

*/
(
OSCdef(\sampleReceiver,
	{
		|msg|
		Synth(\sampleSound,[
			\freq1,40 + (msg[1] + msg[5]).midicps,
			\freq2,40 + (msg[2] + msg[6]).midicps,
			\lpf, (~fundamental + ((msg[1].abs + msg[2].abs) * (~fundamental * 3))),
			\
		]
		);
		("message1 = "+msg[1]).post;
		("  message2 = "+msg[2]).postln;
},'/sampledStitchInfo')
);

// ATTEMPT TWO: Use two oscillators.
// They probably need to be a bit more complicated than this.
// This also makes all pitches totally relative - it uses the

(
SynthDef(\stitchX,
	{
		arg freq = 440, amp = 0.5, atk = 0.01, rel = 0.4, pos = 0, sus = 0;
		var sig,env;
		sig = SinOsc.ar(freq,0,1);
		env = EnvGen.ar(Env.linen(atk,sus,rel),1,doneAction:2);
		sig = sig * env;
		Out.ar(0,Pan2.ar(sig,pos,amp))
	}
).add
)

(
SynthDef(\stitchY,
	{
		arg freq = 440, amp = 0.5, atk = 0.01, rel = 0.4, pos = 0, sus = 0;
		var sig,env;
		sig = SinOsc.ar(freq,0,1);
		env = EnvGen.ar(Env.linen(atk,sus,rel),1,doneAction:2);
		sig = sig * env;
		Out.ar(0,Pan2.ar(sig,pos,amp))
	}
).add
)

// A new version of the sampleReceiver that uses two identical oscillators to map across an X/Y axis
//this sounds horrible
(
OSCdef(\sampleReceiver,
	{
		|msg|
		Synth(\stitchX,
			[\freq, (60 + (msg[1])).midicps]
		);
		Synth(\stitchY,
			[\freq, (60 + (msg[2])).midicps]
		);
},'/sampledStitchInfo')
);

//maybe try this version which uses fundamental frequencies across the grid, then uses grid position to calculate selective low pass filtering on both oscillators

//attempt 2

(
SynthDef(\stitchX,
	{
		arg freq = 440, amp = 0.5, atk = 0.01, rel = 0.1, pos = 0, sus = 0, lpf = 440;
		var sig,env;
		sig = LPF.ar(Saw.ar(freq,1),lpf);
		env = EnvGen.ar(Env.linen(atk,sus,rel),1,doneAction:2);
		sig = sig * env;
		Out.ar(0,Pan2.ar(sig,pos,amp))
	}
).add
)

(
SynthDef(\stitchY,
	{
		arg freq = 440, amp = 0.5, atk = 0.01, rel = 0.1, pos = 0, sus = 0, lpf = 440;
		var sig,env;
		sig = LPF.ar(Saw.ar(freq,1),lpf);
		env = EnvGen.ar(Env.linen(atk,sus,rel),1,doneAction:2);
		sig = sig * env;
		Out.ar(0,Pan2.ar(sig,pos,amp))
	}
).add
)

~fundamental = 40

//this sonification uses resulting grid position to determine frequency of both the saw waves and LPF.
//it's very high and occasionally TOTALLY bugs out
(
OSCdef(\sampleReceiver,
	{
		|msg|
		Synth(\stitchX,
			[\freq, ((msg[1] + msg[5]) * (~fundamental)),
				\lpf, (msg[1] + msg[5])*~fundamental
			]
		);
		Synth(\stitchY,
			[\freq, ((msg[2] + msg[6]) * (~fundamental)),
				\lpf, (msg[2] + msg[6])*~fundamental
			]
		);
},'/sampledStitchInfo')
);

(
OSCdef(\sampleReceiver,
	{
		|msg|
		Synth(\stitchX,
			[\freq, ((msg[1] + msg[5]) * (~fundamental)) / 5,
				\lpf, (msg[1] + msg[5])*~fundamental
			]
		);
		Synth(\stitchY,
			[\freq, (((msg[2] + msg[6]) * (~fundamental)) / 5).post,
				\lpf, ((msg[2] + msg[6])*~fundamental).postln
			]
		);
		msg.postln;
},'/sampledStitchInfo')
);

Tdef(\stitch).play

//There are a bunch of glitches in here that need sorting out, particularly relating to the fact that occasionally Processing will send a message that doesn't make sense, and then SuperCollider will send a nonsense negative saw wave which will make the sound go nuts

//let's send a bunch of sample stitches to Processing here
//DOWNRIGHT
~processing.sendMsg('/stitchSC',1.0,1.0,1)
//RIGHT
~processing.sendMsg('/stitchSC',1.0,0.0,1)
//DOWN
~processing.sendMsg('/stitchSC',0.0,1.0,1)
//UP
~processing.sendMsg('/stitchSC',0.0,-1.0,1)
//DOWNLEFT
~processing.sendMsg('/stitchSC',-1.0,1.0,1)
//UPLEFT
//UP
~processing.sendMsg('/stitchSC',-2.0,-1.0,1)
//LEFT
//If you keep running the thing left, then it craps out and sends negative numbers, which totally send things west.
//maybe adding a 1 to the data in SuperCollider to keep it above negative numbers is a good idea, while
~processing.sendMsg('/stitchSC',-1.0,0.0,1)


(
OSCdef(\sampleReceiver,
	{
		|msg|
		Synth(\stitchX,
			[\freq, (((msg[1] + msg[5] + 1) * (~fundamental)) + 1 / 5).abs,
				\lpf, ((msg[1] + msg[5] + 2)*~fundamental).abs,
				\pan, -0.8
			]
		);
		Synth(\stitchY,
			[\freq, ((((msg[2] + msg[6] + 1) * (~fundamental)) + 1) / 5).abs.post,
				\lpf, ((msg[2] + msg[6] + 2)*~fundamental).abs.postln,
				\pan, 0.8
			]
		);
		msg.postln;
},'/sampledStitchInfo')
);

// This still sounds pretty weak. What I might need is a variable wave selection based on direction
// MAYBE THE LENGTH OF THE STITCH COULD BE USED AS A VARIABLE??!??!?
// MAYBE THE LENGTH OF THE STITCH COULD BE USED AS A VARIABLE??!??!?
// MAYBE THE LENGTH OF THE STITCH COULD BE USED AS A VARIABLE??!??!?
// MAYBE THE LENGTH OF THE STITCH COULD BE USED AS A VARIABLE??!??!?
// MAYBE THE LENGTH OF THE STITCH COULD BE USED AS A VARIABLE??!??!?
// MAYBE THE LENGTH OF THE STITCH COULD BE USED AS A VARIABLE??!??!?

//3rd November

//So there's an error at the end of the stitch array. What could that be?

~stitchHistory[1]

//the list reads as this
List[ [ 0, 0, false, start ], [ -2, 2, false ], [ -2, -2, true ], [ 2, -2, false ], [ 2, 2, true ], [ -2, 2, false ], [ 2, -2, true ], [ -2, -2, false ], [ -2, 2, true, end ] ]

//I actually don't know what the issue is, it's being displayed as this in the processing post window

ERROR @ OscP5 ERROR. an error occured while forwarding an OscMessage
to a method in your program. please check your code for any
possible errors that might occur in the method where incoming
OscMessages are parsed e.g. check for casting errors, possible
nullpointers, array overflows ... .
method in charge : oscEvent  java.lang.reflect.InvocationTargetException
ss### [2017/11/3 9:13:41]

ERROR @ OscP5 ERROR. an error occured while forwarding an OscMessage
to a method in your program. please check your code for any
possible errors that might occur in the method where incoming
OscMessages are parsed e.g. check for casting errors, possible
nullpointers, array overflows ... .
method in charge : oscEvent  java.lang.reflect.InvocationTargetException

//this error doesn't actually make any sense given the fact that /stitchSC seems to be only sending floats and ints...
//this is just a vestige from some old code, trimmed it from language_1.9_Installation.scd

//Okay, so after having a chat with Tom, a few things have emerged:

/*

People need to be able to see their changes, and they need to be able to recognise their own patterns in amongst the patterns that already exist.

But those patterns also need to be obviously affected by the canvas

Another idea was to have individual patterns played WITHIN the larger pattern - something that might take quite a bit more work.

But first, a way to make recognisable musical elements might be a good start.

Pitch arrangement that isn't a MIDI marimba?

Maybe use X/Y or the four corners of the screen to control switching between four waveforms?

*/


//Prototype synth, using position on canvas as a wave
//uses mouse X and Y positions
(
{
	var mouseY = MouseY.kr(-1,1), mouseX = MouseX.kr(-1,1);
	Splay.ar(
		[
			SinOscFB.ar([100,200],1,mouseY.linlin(-1,1,0,1)),
			Pulse.ar([100,200],0.2,mouseY.linlin(-1,1,1,0)),
			Saw.ar([100,200],mouseX.linlin(-1,1,1,0)),
			LFTri.ar([100,200],0,mouseX.linlin(-1,1,0,1))
	])
}.play
)

//good enough. Now to assign that to the overall position of the stitch, then assign that to some musical data?

(
//x and y accept values scaled from -1 to 1.
SynthDef(\stitchSample,
	{
		arg freq = 100, amp = 1, atk = 0.01, sus = 0, rel = 0.3, x = 0, y = 0;
		var sig, env;
		sig = Splay.ar([
			SinOscFB.ar(freq,1,y.linlin(-1,1,0,1)),
			Pulse.ar(freq,0.2,y.linlin(-1,1,1,0)),
			Saw.ar(freq,x.linlin(-1,1,1,0)),
			LFTri.ar(freq,0,x.linlin(-1,1,0,1))
		],1,1,0,true) * amp;
		env = EnvGen.ar(Env.linen(atk,sus,rel,1),1,doneAction:2);
		sig = sig * env;
		Out.ar(0,sig)
}).add;
)

(
Synth(\stitchSample,
	[\freq,Scale.choose.degreeToFreq(rrand(1,10),40.midicps,1),
		\x, rrand(-1,1),
		\y, rrand(-1,1)
	]
)
)

// IN TERMS OF MUSICAL SCALES this seems to begin to be making a kinda bit of sense.
// Every time the canvas is refreshed, a new scale could be generated, and a new root note could be generated.
// This could allow for musical scales to be transposed also when the canvas is refreshed
// This also shows different ways of representing stitches across multiple types of scale(!!)
// so, put a pin in this for now and i'll go do some networking then come back to this.
// 13:15 3rd Nov

//so, going back to this.
//We need to link this up with some kind of \stitchSample OSCdef that will use each loop to pick some kind of scale maybe?
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

//It's not a perfect fit, but if you take into account each direction, then all directions could form an octave scale, with double, triple, quadruple jumps becoming octave jumps on top of that?
//That makes the most sense for now. It then allows participants to see the melodies that they create, but also juxtaposes them across various kinds of scale schema?
//In order to make this a salient connection, i'll need to put a trigger in the clearScreen() function in Processing that will pick a new scale. I'll do this momentarily.


//let's send a bunch of sample stitches to Processing here
//DOWN
~processing.sendMsg('/stitchSC',0.0,1.0,1)
//UP
~processing.sendMsg('/stitchSC',0.0,-1.0,1)
//RIGHT
~processing.sendMsg('/stitchSC',1.0,0.0,1)
//LEFT
~processing.sendMsg('/stitchSC',-1.0,0.0,1)

//DOWNLEFT
~processing.sendMsg('/stitchSC',-1.0,1.0,1)
//UPLEFT
~processing.sendMsg('/stitchSC',-1.0,-1.0,1)

//DOWNRIGHT
~processing.sendMsg('/stitchSC',1.0,1.0,1)
//UPRIGHT
~processing.sendMsg('/stitchSC',1.0,-1.0,1)


//How do I work out the degree of a scale to use?!
//What I need to do is turn the directions into something meaningful i guess
//How do I determine what is 'right, down, upright', etc?

~test = [-12,8]
~test[0] + ~test[1]

//What would be really nice is some kind of locking, so that the sonification is not explicitly dependent upon the scale, but can work within/around it.
//what I need is an algorithm that will parse directions properly.

/*

if x = 0 & y = 1 -> DOWN
if x = 0 & y = -1 -> UP

if x = 1 & y = 0 -> RIGHT
if x = -1 & y = 0 -> LEFT

if x = -1 & y = 1 -> DOWNLEFT
if x = -1 & y = -1 -> UPLEFT

if x = 1 & y = 1 -> DOWNRIGHT
if x = 1 & y = -1 -> UPRIGHT

*/

//Okay, now how do i use these to determine how to use scale degrees?

//Well, OSCdefs can contain if statements, unlike SynthDefs, so that's good.
//Okay, need to figure out how to translate X/Y Co-ords BACK into directions -_-
//Everything goes full circle after all


//DOWN
~superCollider.sendMsg('/stitchSC',0.0,1.0,1)
//UP
~superCollider.sendMsg('/stitchSC',0.0,-1.0,1)
//RIGHT
~superCollider.sendMsg('/stitchSC',1.0,0.0,1)
//LEFT
~superCollider.sendMsg('/stitchSC',-1.0,0.0,1)

//DOWNLEFT
~superCollider.sendMsg('/stitchSC',-1.0,1.0,1)
//UPLEFT
~superCollider.sendMsg('/stitchSC',-1.0,-1.0,1)

//DOWNRIGHT
~superCollider.sendMsg('/stitchSC',1.0,1.0,1)
//UPRIGHT
~superCollider.sendMsg('/stitchSC',1.0,-1.0,1)



//a testing message
~superCollider.sendMsg('/stitchSC',2,-5,1)

/*
//Okay, so this takes the messages sent to SuperCollider, and parses them out as directions. We're back to square one, but we know more.
(
OSCdef(\test,
{
|msg|

//if x = 0
if(msg[1] == 0,
{

//DOWN
if (msg[2] >= 1,
{("DOWN"+msg[2]+"STEPS").postln}
);

//UP
if (msg[2] <= -1,
{("UP"+msg[2].abs+"steps").postln}
);
});

//if x >= 1
if (msg[1] >= 1,
{
//RIGHT
if (msg[2] == 0,
{("RIGHT"+(msg[1])+"STEPS").postln}
);

//DOWNRIGHT
if (msg[2] >= 1,
{("DOWNRIGHT"+msg[1]+msg[2]+"STEPS").postln}
);

//UPRIGHT
if (msg[2] <= -1,
{("UPRIGHT"+msg[1]+msg[2].abs+"STEPS").postln}
)
});

//if x <= -1
if (msg[1] <= -1,
{
//LEFT
if (msg[2] == 0,
{("LEFT"+(msg[1].abs)+"STEPS").postln}
);

//DOWNLEFT
if (msg[2] >= 1,
{("DOWNLEFT"+msg[1]+msg[2]+"STEPS").postln}
);

//UPLEFT
if (msg[2] <= -1,
{("UPLEFT"+msg[1]+msg[2].abs+"STEPS").postln}
)
})
},'/'
)
)
*/

//back to this SynthDef
(
//x and y accept values scaled from -1 to 1.
SynthDef(\stitchSample,
	{
		arg freq = 100, amp = 1, atk = 0.01, sus = 0, rel = 0.3, x = 0, y = 0;
		var sig, env;
		sig = Splay.ar([
			SinOscFB.ar(freq,1,y.linlin(-1,1,0,1)),
			Pulse.ar(freq,0.2,y.linlin(-1,1,1,0)),
			Saw.ar(freq,x.linlin(-1,1,1,0)),
			LFTri.ar(freq,0,x.linlin(-1,1,0,1))
		],1,1,0,true) * amp;
		env = EnvGen.ar(Env.linen(atk,sus,rel,1),1,doneAction:2);
		sig = sig * env;
		Out.ar(0,sig)
}).add;
)

Tdef(\stitch).play

Synth(\stitchSample)

//turning this into a thing that plays scales.
//TODO: PITCH DIAGONALS CORRECTLY - MAYBE WITH QUARTER TONES?
//This does, however, produce a complete scale(!!!!)
//4th November Checkpoint
(
//these are set up clockwise
var up = 0, upright = 1, right = 2, downright = 3, down = 4, downleft = 5, left = 6, upleft = 7, x = 0, y = 0;
OSCdef(\test,
	{
		|msg|

		//set x and y values according to position on canvas at the start of the stitch. Should be easy enough to do, based on the information sent as a packet from Processing
		//Xlen, Ylen, gridSize, ID, newX, newY
		//msg.postln;

		//TODO:

		//YOU NOW NEED TO FIGURE OUT HOW TO TRANSLATE GRID POSITION INTO X/Y AXIS FROM -1 to 1 TO TRANSLATE THEM INTO X AND Y CROSSFADES. DO THIS NOW!

		x = ((msg[5] - msg[1]) / msg[3]).linlin(0,2,-1,1);
		y = ((msg[6] - msg[2]) / msg[3]).linlin(0,2,-1,1);
		("x="+x+"y="+y).postln;


		//if x = 0
		if(msg[1] == 0,
			{

				//DOWN
				if (msg[2] >= 1,
					{//("DOWN"+msg[2]+"STEPS").postln;
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(down,40.midicps,1),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
							]
						);
					}
				);

				//UP
				if (msg[2] <= -1,
					{//("UP"+msg[2].abs+"steps").postln;
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(up,40.midicps,msg[2].abs),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
							]
						);
					}
				);
		});

		//if x >= 1
		if (msg[1] >= 1,
			{
				//RIGHT
				if (msg[2] == 0,
					{//("RIGHT"+(msg[1])+"STEPS").postln;
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(right,40.midicps,1),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
							]
					);}
				);

				//DOWNRIGHT
				if (msg[2] >= 1,
					{//("DOWNRIGHT"+msg[1]+msg[2]+"STEPS").postln;
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(downright,40.midicps,1),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
							]
					);}
				);

				//UPRIGHT
				if (msg[2] <= -1,
					{//("UPRIGHT"+msg[1]+msg[2].abs+"STEPS").postln;
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(upright,40.midicps,1),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
							]
					);}
				)
		});

		//if x <= -1
		if (msg[1] <= -1,
			{
				//LEFT
				if (msg[2] == 0,
					{//("LEFT"+(msg[1].abs)+"STEPS").postln;
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(left,40.midicps,1),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
							]
					);}
				);

				//DOWNLEFT
				if (msg[2] >= 1,
					{//("DOWNLEFT"+msg[1]+msg[2]+"STEPS").postln;
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(downleft,40.midicps,1),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
							]
					);}
				);

				//UPLEFT
				if (msg[2] <= -1,
					{//("UPLEFT"+msg[1]+msg[2].abs+"STEPS";
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(upleft,40.midicps,1),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
							]
					);}
				)
		})
	},'/sampledStitchInfo'
)
)

//THIS WORKS!!!!! - Together they form a complete sonidication, but we now need to handle the octaves.
//Also there's not enough differentiation in the types of waves being used here.

(
//x and y accept values scaled from -1 to 1.
SynthDef(\stitchSample,
	{
		arg freq = 100, amp = 1, atk = 0.01, sus = 0, rel = 0.3, x = 0, y = 0;
		var sig, env;
		sig = Splay.ar([
			//a linexp is used here in an attempt to get more wave differentiation
			//what I really want is quiet in the middle, loud at the edges
			SinOscFB.ar(freq,1,(y.linlin(-1,1,0.01,1)).linexp(0.01,1,0.01,1) - 0.01),
			Pulse.ar(freq,0.2,(y.linlin(-1,1,1,0.01)).linexp(0.01,1,0.01,1) - 0.01),
			Saw.ar(freq,(x.linlin(-1,1,1,0.01)).linexp(0.01,1,0.01,1) - 0.01),
			LFTri.ar(freq,0,(x.linlin(-1,1,0.01,1)).linexp(0.01,1,0.01,1) - 0.01)
		],1,1,0,true) * amp;
		env = EnvGen.ar(Env.linen(atk,sus,rel,1),1,doneAction:2);
		sig = sig * env;
		Out.ar(0,sig)
}).add;
)

Array.fill(4,{Synth(\stitchSample,[\freq,rrand(1,10) * 100])})

//Here's a quick and dirty Tdef for removing the last entry of the sample library
//TODO: This could do with being scaled according to how many patterns are currently in the library,
(
Tdef(\sampleCleaner,
	{ loop ({
		1.wait;
		//if the array is empty
		if(~stitchHistory[0] != nil,
			{

				~stitchHistory.removeAt(0);
				"Oldest pattern removed!".postln;
		});
	})}
)
)

Tdef(\sampleCleaner).play

~stitchHistory.size

~stitchHistory = File("~/src/github/Sampler-Sampler/SuperCollider/savedStitches/stitches_install.~txt".standardizePath,"r").readAllString.interpret

//Let's take another look at this Tdef, and how we're going to make it interesting
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

//Tdef for sample playback
//here's a super simple way to make it interesting
//NOTE: on here, there's actually no controls for sonification.
//There's a way to sort this now but i'm not actually sure how
(
Tdef(\stitch,
	{ loop ({
		~loopPattern.(
			pattern:rrand(0,~stitchHistory.size-1),
			period:rrand(0.01,2),
			num:1,
			delay:rrand(0,10.0),
			transform:0,
			multiplier:1,
		);
	})}
)
)

Tdef(\stitch).play

// Here's an attempt to get the sonification looking and sounding a bit more varied



//re-defining the envelope time, number of repetitions and the playback time.
//this is done randomly - seems to actually work quite nicely as it stands
(
Tdef(\stitch,
	{ loop ({
		var time = rrand(0.01,0.5) / 2, delay = rrand(0,3.0) / 2, repetitions = [1,1,1,1,1,1,2,3,4,5,6].choose, envTime, attack;

		//redefine the envelope time relti
		envTime = (time * rrand(0.1,2.5));
		attack = (time * rrand(0.01,0.4));

		//re-define the synthDef with new attack
		SynthDef(\stitchSample,
			{
				arg freq = 100, amp = 1, atk = 0.01, sus = 0, rel = 0.1, x = 0, y = 0;
				var sig, env;
				sig = Splay.ar([
					//a linexp is used here in an attempt to get more wave differentiation
					//what I really want is quiet in the middle, loud at the edges
					SinOscFB.ar(freq,1,(y.linlin(-1,1,0.01,1)).linexp(0.01,1,0.01,1) - 0.01),
					Pulse.ar(freq,0.2,(y.linlin(-1,1,1,0.01)).linexp(0.01,1,0.01,1) - 0.01),
					Saw.ar(freq,(x.linlin(-1,1,1,0.01)).linexp(0.01,1,0.01,1) - 0.01),
					LFTri.ar(freq,0,(x.linlin(-1,1,0.01,1)).linexp(0.01,1,0.01,1) - 0.01)
				],1,1,0,true) * amp;
				env = EnvGen.ar(Env.linen(attack,sus,envTime,1),1,doneAction:2);
				sig = sig * env;
				Out.ar(0,sig)
		}).add;

		~loopPattern.(
			pattern:rrand(0,~stitchHistory.size-1),
			period:time,
			num:repetitions,
			delay:delay,
			transform:0,
			multiplier:1,
		);
	})}
)
);

//Second version of sonification - altering pitchess & pitch classes according to the movement of stitches!
//this uses the 'distance' of a stitch as an octave modifier
//if this ends up too low for EVERYTHING, then the basePitch needs increasing...
//THE OCTAVE OF THE DIAGONALS SHOULD BE THE ROUNDED MEDIAN BETWEEN THE TWO VALUES!!!
//That's a nice way of solving this problem.
//I did read in the sonification book that longer lengths should mean lower pitches though,
//and that makes a lot of sense because that's how strings work and resonate.
(
//these are set up clockwise
var up = 0, upright = 1, right = 2, downright = 3, down = 4, downleft = 5, left = 6, upleft = 7, x = 0, y = 0, basePitch = 24, root = 0, diagonalCalc, atk, rel;
OSCdef(\test,
	{
		|msg|

		root = ~root;


		//set x and y values according to position on canvas at the start of the stitch. Should be easy enough to do, based on the information sent as a packet from Processing
		//Xlen, Ylen, gridSize, ID, newX, newY
		//msg.postln;

		//TODO:

		//YOU NOW NEED TO FIGURE OUT HOW TO TRANSLATE GRID POSITION INTO X/Y AXIS FROM -1 to 1 TO TRANSLATE THEM INTO X AND Y CROSSFADES. DO THIS NOW!

		x = ((msg[5] - msg[1]) / msg[3]).linlin(0,2,-1,1);
		y = ((msg[6] - msg[2]) / msg[3]).linlin(0,2,-1,1);
		//("x="+x+"y="+y).postln

		//(msg[1].asString + msg[2].asString).postln;


		diagonalCalc.postln;

		//if x = 0
		if(msg[1] == 0,
			{

				//DOWN
				if (msg[2] >= 1,
					{//("DOWN"+msg[2]+"STEPS").postln;
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(down,(basePitch + root).midicps,msg[2] - 1),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
							]
						);
					}
				);

				//UP
				if (msg[2] <= -1,
					{//("UP"+msg[2].abs+"steps").postln;
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(up,(basePitch + root).midicps,msg[2].abs - 1),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
							]
						);
					}
				);
		});

		//if x >= 1
		if (msg[1] >= 1,
			{
				//RIGHT
				if (msg[2] == 0,
					{//("RIGHT"+(msg[1])+"STEPS").postln;
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(right,(basePitch + root).midicps,msg[1] - 1),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
							]
					);}
				);

				//DOWNRIGHT
				if (msg[2] >= 1,
					{//("DOWNRIGHT"+msg[1]+msg[2]+"STEPS").postln;
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(downright,(basePitch + root).midicps,(((msg[1].abs + msg[2].abs)/2).round(1)).abs),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
							]
					);}
				);

				//UPRIGHT
				if (msg[2] <= -1,
					{//("UPRIGHT"+msg[1]+msg[2].abs+"STEPS").postln;
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(upright,(basePitch + root).midicps,(((msg[1].abs + msg[2].abs)/2).round(1)).abs),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
							]
					);}
				)
		});

		//if x <= -1
		if (msg[1] <= -1,
			{
				//LEFT
				if (msg[2] == 0,
					{//("LEFT"+(msg[1].abs)+"STEPS").postln;
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(left,(basePitch + root).midicps,msg[1].abs - 1),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
							]
					);}
				);

				//DOWNLEFT
				if (msg[2] >= 1,
					{//("DOWNLEFT"+msg[1]+msg[2]+"STEPS").postln;
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(downleft,(basePitch + root).midicps,(((msg[1].abs + msg[2].abs)/2).round(1)).abs),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
							]
					);}
				);

				//UPLEFT
				if (msg[2] <= -1,
					{//("UPLEFT"+msg[1]+msg[2].abs+"STEPS";
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(upleft,(basePitch + root).midicps,(((msg[1].abs + msg[2].abs)/2).round(1)).abs),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
							]
					);}
				)
		})
	},'/sampledStitchInfo'
)
);

//Third version of the sonification.
//This one inverts the scale relationship between octave and length. short stitches have a high pitch and longer stitches have a lower pitch
//Because strings do this, is my reasoning.
//variable maxOctave sets the maximum octave that can be played
//Maybe this needs to be so that the envelope time is set in the OSCdef, rather than outside of it?
(
//these are set up clockwise
var up = 0, upright = 1, right = 2, downright = 3, down = 4, downleft = 5, left = 6, upleft = 7, x = 0, y = 0, basePitch = 24, root = 0, diagonalCalc, maxOctave = 6, attack, release;
OSCdef(\test,
	{
		|msg|

		root = ~root;
		diagonalCalc = (maxOctave - (((msg[1].abs + msg[2].abs)/2).round(1)).abs) - 1;

		//set x and y values according to position on canvas at the start of the stitch. Should be easy enough to do, based on the information sent as a packet from Processing
		//Xlen, Ylen, gridSize, ID, newX, newY
		//msg.postln;

		//TODO:

		//YOU NOW NEED TO FIGURE OUT HOW TO TRANSLATE GRID POSITION INTO X/Y AXIS FROM -1 to 1 TO TRANSLATE THEM INTO X AND Y CROSSFADES. DO THIS NOW!

		x = ((msg[5] - msg[1]) / msg[3]).linlin(0,2,-1,1);
		y = ((msg[6] - msg[2]) / msg[3]).linlin(0,2,-1,1);
		//("x="+x+"y="+y).postln

		//(msg[1].asString + msg[2].asString).postln;


		diagonalCalc.postln;

		//if x = 0
		if(msg[1] == 0,
			{

				//DOWN
				if (msg[2] >= 1,
					{//("DOWN"+msg[2]+"STEPS").postln;
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(down,(basePitch + root).midicps,maxOctave - (msg[2] - 1)),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
							]
						);
					}
				);

				//UP
				if (msg[2] <= -1,
					{//("UP"+msg[2].abs+"steps").postln;
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(up,(basePitch + root).midicps,maxOctave - (msg[2].abs - 1)),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
							]
						);
					}
				);
		});

		//if x >= 1
		if (msg[1] >= 1,
			{
				//RIGHT
				if (msg[2] == 0,
					{//("RIGHT"+(msg[1])+"STEPS").postln;
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(right,(basePitch + root).midicps,maxOctave - (msg[1] - 1)),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
							]
					);}
				);

				//DOWNRIGHT
				if (msg[2] >= 1,
					{//("DOWNRIGHT"+msg[1]+msg[2]+"STEPS").postln;
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(downright,(basePitch + root).midicps,diagonalCalc),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
							]
					);}
				);

				//UPRIGHT
				if (msg[2] <= -1,
					{//("UPRIGHT"+msg[1]+msg[2].abs+"STEPS").postln;
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(upright,(basePitch + root).midicps,diagonalCalc),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
							]
					);}
				)
		});

		//if x <= -1
		if (msg[1] <= -1,
			{
				//LEFT
				if (msg[2] == 0,
					{//("LEFT"+(msg[1].abs)+"STEPS").postln;
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(left,(basePitch + root).midicps,maxOctave - (msg[1].abs - 1)),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
							]
					);}
				);

				//DOWNLEFT
				if (msg[2] >= 1,
					{//("DOWNLEFT"+msg[1]+msg[2]+"STEPS").postln;
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(downleft,(basePitch + root).midicps,diagonalCalc),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
							]
					);}
				);

				//UPLEFT
				if (msg[2] <= -1,
					{//("UPLEFT"+msg[1]+msg[2].abs+"STEPS";
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(upleft,(basePitch + root).midicps,diagonalCalc),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
							]
					);}
				)
		})
	},'/sampledStitchInfo'
)
);



//Fourth version of sonification - this time using global attack and release values which are redefined with the canvas is redrawn
(
//these are set up clockwise
var up = 0, upright = 1, right = 2, downright = 3, down = 4, downleft = 5, left = 6, upleft = 7, x = 0, y = 0, basePitch = 24, root = 0, diagonalCalc, maxOctave = 6, attack, release;
OSCdef(\test,
	{
		|msg|

		//set global variables
		root = ~root;
		attack = ~attack;
		release = ~release;
		diagonalCalc = (maxOctave - (((msg[1].abs + msg[2].abs)/2).round(1)).abs) - 1;

		//set x and y values according to position on canvas at the start of the stitch. Should be easy enough to do, based on the information sent as a packet from Processing
		//Xlen, Ylen, gridSize, ID, newX, newY
		//msg.postln;

		//TODO:

		//YOU NOW NEED TO FIGURE OUT HOW TO TRANSLATE GRID POSITION INTO X/Y AXIS FROM -1 to 1 TO TRANSLATE THEM INTO X AND Y CROSSFADES. DO THIS NOW!

		x = ((msg[5] - msg[1]) / msg[3]).linlin(0,2,-1,1);
		y = ((msg[6] - msg[2]) / msg[3]).linlin(0,2,-1,1);
		//("x="+x+"y="+y).postln

		//(msg[1].asString + msg[2].asString).postln;


		diagonalCalc.postln;

		//if x = 0
		if(msg[1] == 0,
			{

				//DOWN
				if (msg[2] >= 1,
					{//("DOWN"+msg[2]+"STEPS").postln;
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(down,(basePitch + root).midicps,maxOctave - (msg[2] - 1)),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
								\atk,~attack,
								\rel,~release,
							]
						);
					}
				);

				//UP
				if (msg[2] <= -1,
					{//("UP"+msg[2].abs+"steps").postln;
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(up,(basePitch + root).midicps,maxOctave - (msg[2].abs - 1)),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
								\atk,~attack,
								\rel,~release,
							]
						);
					}
				);
		});

		//if x >= 1
		if (msg[1] >= 1,
			{
				//RIGHT
				if (msg[2] == 0,
					{//("RIGHT"+(msg[1])+"STEPS").postln;
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(right,(basePitch + root).midicps,maxOctave - (msg[1] - 1)),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
								\atk,~attack,
								\rel,~release,
							]
					);}
				);

				//DOWNRIGHT
				if (msg[2] >= 1,
					{//("DOWNRIGHT"+msg[1]+msg[2]+"STEPS").postln;
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(downright,(basePitch + root).midicps,diagonalCalc),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
								\atk,~attack,
								\rel,~release,
							]
					);}
				);

				//UPRIGHT
				if (msg[2] <= -1,
					{//("UPRIGHT"+msg[1]+msg[2].abs+"STEPS").postln;
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(upright,(basePitch + root).midicps,diagonalCalc),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
								\atk,~attack,
								\rel,~release,
							]
					);}
				)
		});

		//if x <= -1
		if (msg[1] <= -1,
			{
				//LEFT
				if (msg[2] == 0,
					{//("LEFT"+(msg[1].abs)+"STEPS").postln;
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(left,(basePitch + root).midicps,maxOctave - (msg[1].abs - 1)),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
								\atk,~attack,
								\rel,~release,
							]
					);}
				);

				//DOWNLEFT
				if (msg[2] >= 1,
					{//("DOWNLEFT"+msg[1]+msg[2]+"STEPS").postln;
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(downleft,(basePitch + root).midicps,diagonalCalc),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
								\atk,~attack,
								\rel,~release,
							]
					);}
				);

				//UPLEFT
				if (msg[2] <= -1,
					{//("UPLEFT"+msg[1]+msg[2].abs+"STEPS";
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(upleft,(basePitch + root).midicps,diagonalCalc),
								//TODO: handle how this is used.
								\x,x,
								\y,y,
								\atk,~attack,
								\rel,~release,
							]
					);}
				)
		})
	},'/sampledStitchInfo'
)
);


//so now the properties of the synth don't need to be redefined inside of this Tdef they are defined according to information taken from Processing (Stitch direction and length)
(
Tdef(\stitch,
	{ loop ({
		var time = rrand(0.01,0.5) / 2, delay = rrand(0,3.0) / 2, repetitions = [1,1,1,1,1,1,2,3,4,5,6].choose, envTime, attack;

		~loopPattern.(
			pattern:rrand(0,~stitchHistory.size-1),
			period:time,
			num:repetitions,
			delay:delay,
			transform:0,
			multiplier:1,
		);
	})}
)
);

Tdef(\stitch).play

///NOVEMBER 6TH - THE ABOVE FOR A COMPLETE DUO OF SONIFICATION + SEQUENCING

//NOVEMBER 6TH - SECOND ATTEMPT AT SONIFYING STITCH INPUT DATA. THIS IS GOING TO BE A TOTAL OVERHAUL

//This is going to use the scale degrees, to determine pitch, and use the distance of the thread to determine the LPF cutoff frequency

//first the SynthDef
(
SynthDef(\clickSound,
	{
		arg freq1 = 300, freq2 = 400, lpf = 1000, amp = 0.5, pan = 0, atk = 4, dec = 0.3, sus = 0.5, rel = 1, trig = 1;
		var sig, env;
		sig = LPF.ar(Saw.ar(freq1.slew(300,300),1) * SinOsc.ar(freq2.slew(4000,4000),3).unipolar,lpf.slew(500,500),1);
		env = EnvGen.ar(Env.adsr(atk,dec,sus,rel),trig,doneAction:2);
		sig = sig * env;
		Out.ar(0,Pan2.ar(LeakDC.ar(sig),pan,amp * 4));
}).add;
);

(
//NOTE: these will all need to be renamed upClick etc.
var upClick = 0, uprightClick = 1, rightClick = 2, downrightClick = 3, downClick = 4, downleftClick = 5, leftClick = 6, upleftClick = 7, basePitchClick = 24, rootClick = 0, diagonalCalcClick, maxOctave = 6;
~fundamental = 50;
~stitches = Array.newClear(5000);


(
// this sets up a variable for the synth to access
// the OSCdef controlling how the synth is accessed
OSCdef(\clicked,
	{
		|msg, time, addr, recvPort|

		msg.postln;

		rootClick = ~root;

		//this instantiates the synth
		~stitches[msg[4]] = Synth.new(\clickSound,[
			\freq1,(~scale.degreeToFreq(0,(basePitchClick + rootClick).midicps,2)),
			\freq2,(~scale.degreeToFreq(0,(basePitchClick + rootClick).midicps,2)),
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


		//RIGHT NOW, you need to convert thread DISTANCE into LPF values

		diagonalCalcClick = ((msg[1].abs + msg[2].abs)/2).postln;

		//set properties on previously-enabled synths
		// this adds a 'starting frequency' to the frequencies used in the sonification
		//
		if((msg[1] / msg[3]) == 0,
			{

				//DOWN
				if ((msg[2] / msg[3]) >= 1,
					{//("DOWN"+msg[2]+"STEPS").postln;
						"here".postln;
						~stitches[msg[4]].set(
							\freq1,~scale.degreeToFreq(down,(basePitchClick + rootClick).midicps,2),
							\freq2,~scale.degreeToFreq(down,(basePitchClick + rootClick).midicps,2) / 2,
							//todo: scale LPF
							\lpf,msg[2]
						);
					}
				);

				//UP
				if ((msg[2] / msg[3]) <= -1,
					{//("UP"+msg[2].abs+"steps").postln;
						~stitches[msg[4]].set(
							\freq1,~scale.degreeToFreq(up,(basePitchClick + rootClick).midicps,2),
							\freq2,~scale.degreeToFreq(up,(basePitchClick + rootClick).midicps,2) / 2,
							//todo: scale LPF
							\lpf,msg[2].abs
						);

					}
				);
		});


		if ((msg[1] / msg[3]) >= 1,
			{
				//RIGHT
				if ((msg[2] / msg[3]) == 0,
					{//("RIGHT"+(msg[1])+"STEPS").postln;
						~stitches[msg[4]].set(
							\freq1,~scale.degreeToFreq(right,(basePitchClick + rootClick).midicps,2),
							\freq2,~scale.degreeToFreq(right,(basePitchClick + rootClick).midicps,2) / 2,
							//todo: scale LPF
							\lpf,msg[1].abs
						);
					}
				);

				//DOWNRIGHT
				if ((msg[2] / msg[3]) >= 1,
					{//("DOWNRIGHT"+msg[1]+msg[2]+"STEPS").postln;
						~stitches[msg[4]].set(
							\freq1,~scale.degreeToFreq(downright,(basePitchClick + rootClick).midicps,2),
							\freq2,~scale.degreeToFreq(downright,(basePitchClick + rootClick).midicps,2) / 2,
							//todo: scale LPF
							\lpf,diagonalCalcClick
						);
					}
				);

				//UPRIGHT
				if ((msg[2] / msg[3]) <= -1,
					{//("UPRIGHT"+msg[1]+msg[2].abs+"STEPS").postln;
						~stitches[msg[4]].set(
							\freq1,~scale.degreeToFreq(upright,(basePitchClick + rootClick).midicps,2),
							\freq2,~scale.degreeToFreq(upright,(basePitchClick + rootClick).midicps,2) / 2,
							//todo: scale LPF
							\lpf,diagonalCalcClick
						);
					}
				)
		});

		//if x <= -1
		if ((msg[1] / msg[3]) <= -1,
			{
				//LEFT
				if ((msg[2] / msg[3]) == 0,
					{//("LEFT"+(msg[1].abs)+"STEPS").postln;
						~stitches[msg[4]].set(
							\freq1,~scale.degreeToFreq(left,(basePitchClick + rootClick).midicps,2),
							\freq2,~scale.degreeToFreq(left,(basePitchClick + rootClick).midicps,2) / 2,
							//todo: scale LPF
							\lpf,msg[1].abs
						);
					}
				);

				//DOWNLEFT
				if ((msg[2] / msg[3]) >= 1,
					{//("DOWNLEFT"+msg[1]+msg[2]+"STEPS").postln;
						~stitches[msg[4]].set(
							\freq1,~scale.degreeToFreq(downleft,(basePitchClick + rootClick).midicps,2),
							\freq2,~scale.degreeToFreq(downleft,(basePitchClick + rootClick).midicps,2) / 2,
							//todo: scale LPF
							\lpf,diagonalCalcClick
						);

					}
				);

				//UPLEFT
				if ((msg[2] / msg[3]) <= -1,
					{//("UPLEFT"+msg[1]+msg[2].abs+"STEPS";
						~stitches[msg[4]].set(
							\freq1,~scale.degreeToFreq(upleft,(basePitchClick + rootClick).midicps,2),
							\freq2,~scale.degreeToFreq(upleft,(basePitchClick + rootClick).midicps,2) / 2,
							//todo: scale LPF
							\lpf,diagonalCalcClick
						);

					}
				)
		})

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
);
