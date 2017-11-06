

(
//these are set up clockwise
var up = 0, upright = 1, right = 2, downright = 3, down = 4, downleft = 5, left = 6, upleft = 7, x = 0, y = 0, root = 40;
~logging = 0;
~stitchHistory = List.new;
~processing = NetAddr.new("127.0.0.1",12000);
~superCollider = NetAddr.new("127.0.0.1",57120);
~scale = Scale.choose;
//this is necessary for communicating between the OSCdef and the loops
~root = 0;
//default attack and release values, reset every time the canvas refreshes
~attack = 0.01;
~release = 0.1;

// Receives a dump of stitch information
(
OSCdef(\makeStitchArray,
	{
		|msg, time, addr, recvPort, sw, stitch|

		if ( ~logging != 0 , {
			//dump the contents of the message to an array inside the ~stitchHistory list
			~stitchHistory[~stitchHistory.size-1].add([msg[1],msg[2],msg[3]])
		})
},'/stitchInfo')
);

(
OSCdef(\stitchListener,
	{
		|msg, time, addr, recvPort, sw, stitch|

		if ( ~stitchHistory.size > 40, {
		"Max Patterns Reached! - Replacing Oldest Pattern".postln;
		~stitchHistory.removeAt(0);
		});

		if (msg[1] == 1,
			{
				//make a new list for things to be dumped to
				~stitchHistory.add(List.new);
				//start data logging by flipping this
				~logging = 1;
				"logging data".postln;
			},
			{
				~logging = 0;
				//if the array ended up being empty after information has been dumped to it, snip it from the array because it's just going to bog down the installation and it's an easy spam trap if someone just mashes the buttons
				if ( ~stitchHistory[~stitchHistory.size-1].size == 0 ,
					{ ~stitchHistory.removeAt(~stitchHistory.size-1);
						"empty index removed".postln;
					}
				);
				//append an extra integer to the end message, so that Processing knows to log the final x/y values
				~stitchHistory[~stitchHistory.size-1][~stitchHistory[~stitchHistory.size-1].size-1].add("end");
				//append an extra string to the start message so that processing knows to recognise this as the starting co-ords
				~stitchHistory[~stitchHistory.size-1][0].add("start");
				"no longer logging data".postln;
		})
},'/stitchListener')
);

(
~playPattern = {
	arg pattern = 0, period = 0.1, modifier = 0, multiplier = 1, long = 0;
	Task({
		arg listNum = 0;
		var data;
		data = ~stitchHistory[pattern];
		//iterate over the data as a local variable
		data.size.do({
			|i|

			//send stitch data to Processing to be displayed there
			//this will volley back another set of info
			//this is multiplied by minus one because the data was being logged backwards
			~processing.sendMsg('/stitchSC',(data[i][0]) * -1.0,(data[i][1]) * -1.0,data[i][2]);
			~superCollider.sendMsg('/stitchSC',(data[i][0]) * -1,(data[i][1]) * -1,data[i][2]);
			//data[i].postln;
			//~superCollider.sendMsg('/stitchSC',(data[i][0]) * -1,(data[i][1]) * -1,data[i][2]);
			period.wait;
		});
		~noHistory = 0;
	}).play;
};
);


(
~loopPattern = {
	arg pattern = 0, period = 0.1, num = 1, delay = 0.1, transform = 0, multiplier = 1, long = 0, dir1 = "NONE", len1 = "NONE", dir2 = "NONE", len2 = "NONE";
	var numReps = 1;
	//this stops the server crashing, casting the number of repetitions as >0
	if ( num < 1 , { numReps = 1 }, { numReps = num.asInt});
	("Playing Pattern"+pattern).postln;
	numReps.do({
		//use playPattern function
		//"Playing Pattern ".post;
		//pattern.post;
		~playPattern.(pattern,period,transform, multiplier, long);
		//wait for as long as it takes to play the pattern - this seems inefficient and i should probably just re-write the function with ~playPattern within it, but maybe not.
		((~stitchHistory[pattern].size)*period).wait;
		//send the modifiers
		//NO LONGER NEEDED
		//~processing.sendMsg('/stitchSC',dir1,len1);
		//~processing.sendMsg('/stitchSC',dir2,len2);
		delay.wait;
	})
};
);

(
//switch active scale when screen is cleared
OSCdef(\screenClear,
	{
		//new scale set with canvas refresh
		~scale = Scale.choose;
		//new root set with canvas refresh
		~root = rrand(-4,4);
		//TODO: Maybe relate attack and release, but also not.
		//new attack set with canvas refresh
		~attack = rrand(0.01,0.4);
		//new release set with canvas refresh
		~release = rrand(0.1,2);
	},'/screenCleared'
)
);

//a functioning prototype for touch screen sonification'
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
);

//touch screen SynthDef
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
);

//sample playback synthdef
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


//OSCdef for handling sampled stitch messages
(
//these are set up clockwise
//var up = 0, upright = 1, right = 2, downright = 3, down = 4, downleft = 5, left = 6, upleft = 7, x = 0, y = 0, root = 40;
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
//		("x="+x+"y="+y).postln;


		//if x = 0
		if(msg[1] == 0,
			{

				//DOWN
				if (msg[2] >= 1,
					{//("DOWN"+msg[2]+"STEPS").postln;
						Synth(\stitchSample,
							[
								\freq,~scale.degreeToFreq(down,root.midicps,1),
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
								\freq,~scale.degreeToFreq(right,root.midicps,1),
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
								\freq,~scale.degreeToFreq(downright,root.midicps,1),
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
								\freq,~scale.degreeToFreq(upright,root.midicps,1),
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
								\freq,~scale.degreeToFreq(left,root.midicps,1),
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
								\freq,~scale.degreeToFreq(downleft,root.midicps,1),
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
								\freq,~scale.degreeToFreq(upleft,root.midicps,1),
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

/*

THESE WERE REMOVED BECAUSE IT SEEMED TO BE CAUSING SOME ISSUES

//Here's a quick and dirty Tdef for removing the last entry of the sample library
//TODO: This could do with being scaled according to how many patterns are currently in the library,
(
Tdef(\sampleCleaner,
	{ loop ({
		(60 - ~stitchHistory.size).wait;
		//if the array is empty
		if(~stitchHistory[0] != nil,
			{

				~stitchHistory.removeAt(0);
				"Oldest pattern removed!".postln;
		});
	})}
)
);

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
*/

//end
)