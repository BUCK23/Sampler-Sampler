// This file is the only file needed to operate the live coding language, with the relevant functions that comprise the language being loaded in the .loadRelative below

//Load microlanguage, note: only do this at the START of your session
(
s.waitForBoot({
//("Language/language_0.6.scd").loadRelative;
~keyboardResponder.();
~sampleResponder.();
~hostPatternControl.();
//OPTIONAL: StageLimiter, depends on BatLib Quark
StageLimiter.activate;
//These Ndefs are used to hold effects, which are constructed around the In.ar of each class
(Ndef(\keyboardEffects,
	{
		var in = In.ar(4,2);
		in;
}););
Ndef(\keyboardEffects).play;
Ndef(\keyboardEffects).fadeTime = 10;
(Ndef(\samplerEffects,
	{
		var in = In.ar(6,2);
		in;
}););
Ndef(\samplerEffects).play;
Ndef(\samplerEffects).fadeTime = 10;
});
)

//if you hard stop SCLang, run this block to get functionality back, or you will lose stored patterns.
(
~keyboardResponder.(80);
~sampleResponder.();
~hostPatternControl.();
(Ndef(\keyboardEffects,
	{
		var in = In.ar(4,2);
		in;
}););
Ndef(\keyboardEffects).play;
Ndef(\keyboardEffects).fadeTime = 10;
(Ndef(\samplerEffects,
	{
		var in = In.ar(6,2);
		in;
}););
Ndef(\samplerEffects).play;
Ndef(\samplerEffects).fadeTime = 10;
)

//a way to load patterns dry
~stitchHistory = File("~/src/github/Sampler-Sampler/SuperCollider/savedStitches/stitches.txt".standardizePath,"r").readAllString.interpret

~stitchHistory[2][2]

//Task Definition to build stitches,  see examples/documentation for how to use
//dir1 and len1 = direction and length of modifier - 0 = normal, 1 = double
//dir2 and len2 "  "    "
//transform = value added to all values in pattern
//multiplier = multiplication performed on all values in pattern
//Parallel Tdefs can be created, which gives an interesting set of results.
(
~clearScreen.(80);
Tdef(\stitch,
	{
	var pat6 = [5,6,7].scramble, i = 0;
		loop ({
		i = i+1;
		~loopPattern.(
				pattern:3,
			period:[0.01,0.01,0.06].choose,
			num:1,
			delay:[0,0,0,1,0].choose,
			transform:0,
			multiplier:1,
				dir1:(0..7).choose,
				len1:0
		);
		~sampleResponder.(
			freq:((1..40)*100).choose,
				amp:0.05,
			atk:0.001,
			rel:0.1,
			pan:0,
			envMul:2
		);
	})}
)
)

~stitchHistory.size

Tdef(\stitch).play

~clearScreen.(90)



(
Tdef(\stitchPar,
	{ loop ({
		~loopPattern.(
			pattern:0,
			period:0.1/10,
			num:1,
			delay:[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10].choose,
			transform:0,
			multiplier:1,
			dir1:(0..7).choose,
			len1:0
		);
		~sampleResponder.(
			freq:[80,90,100,110,130].choose,
			amp:0.04,
			atk:0.05,
			rel:0.05,
			pan:0,
			envMul:2
		);
	})}
)
)

Tdef(\stitchPar).play;
Tdef(\stitch).play;

//keyboard effects - default
(Ndef(\keyboardEffects,
	{
		var in = In.ar(4,2);
		CombN.ar(in,1,0.3,10);
}););


Ndef(\samplerEffects).play

//sampler effects - default
(Ndef(\samplerEffects,
	{
		// XFade2.ar(In.ar(6,2),Ringz.ar(In.ar(6,2),[100,300],0.1,0.3),0.6)
}););

Ndef(\samplerEffects).play
Ndef(\samplerEffects).clear

(
Tdef(\screen,{
	loop{~clearScreen.(rrand(15,30));
		exprand(0.001,50).wait;
}})
)
Tdef(\screen).play
//scratchpad goes here:
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////

(
Tdef(\stitch,
	{ loop ({
		~loopPattern.(
			pattern:8,
			period:0.1,
			num:1,
			delay:0,
			transform:0,
			multiplier:1,
			dir1:(0..7).choose,
			len1:0
		);
		~sampleResponder.(
			freq:[400,2000,3000,100,200,300,3000,4000,5000].choose,
			amp:0.4,
			atk:0.01,
			rel:0.2,
			pan:0,
			envMul:2
		);
	})}
)
)

Tdef(\stitch).play

//2


(
Tdef(\stitchPar,
	{ loop ({
		~loopPattern.(
			pattern:9,
			period:0.1,
			num:1,
			delay:0.1,
			transform:[0,4,2,3].choose,
			multiplier:1,
			dir1:(0..7).choose,
			len1:1
		);
		~sampleResponder.(
			freq:(1..10).choose*1000,
			amp:0.4,
			atk:0.01,
			rel:0.01,
			pan:0,
			envMul:2
		);
	})}
)
)

Tdef(\stitch).stop

Tdef(\stitchPar).play

(Ndef(\samplerEffects,
	{
		In.ar(6,2)
}););


Ndef(\samplerEffects).fadeTime = 5

Ndef(\samplerEffects).play

Ndef(\samplerEffects).clear

(
Ndef(\theThing,
	Pbind(\instrument,\none,\thing,Pfunc({~playPattern.()}))
)
)

~sampleResponder.(
			freq:rrand(100,401),
			amp:0.01,
			atk:0.01,
			rel:0.5,
			pan:rrand(-1,1),
			envMul:2
		);


Ndef(\theThing).play

(
Tdef(\stitch,
	{ loop ({
		~loopPattern.(
			pattern:0,
			period:0.01,
			num:1,
			delay:0.1,
			transform:rrand(-4,4),
			multiplier:rrand(1,3),
			modifier1:"NONE",
			modifier2:"NONE",
			modifier3:"NONE",
			modifier4:"NONE",
		);
		~sampleResponder.(
			freq:rrand(100,401),
			amp:0.01,
			atk:0.01,
			rel:0.5,
			pan:rrand(-1,1),
			envMul:2
		);
	})}
)
)

~stitchHistory

Tdef(\stitch).play

~clearScreen.(20)

OSCFunc.tracefer


(
Tdef(\stitch,
	{ loop ({
		~loopPattern.(
			pattern:2,
			period:0.01,
			num:1,
			delay:0.01,
			transform:0,
			multiplier:1,
			dir1:[1,6,2].choose,
			len1:0,
		);
		~sampleResponder.(
			freq:[400,900].choose,
			amp:0.3,
			atk:0.03,
			rel:0.03,
			pan:0,
			envMul:2
		);
	})}
)
)

~clearScreen.(80)


Ndef(\samplerEffects).play

(Ndef(\samplerEffects,
	{
		var in = In.ar(6,2);
		CombC.ar(in,1,0.4,3)
}););
