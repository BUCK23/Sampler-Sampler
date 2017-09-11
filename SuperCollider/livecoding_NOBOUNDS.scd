// This file is the only file needed to operate the live coding language, with the relevant functions that comprise the language being loaded in the .loadRelative below

//Load microlanguage, note: only do this at the START of your session
(
("Language/language_0.8.scd").loadRelative;
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
)

//if you hard stop SCLang, run this block to get functionality back, or you will lose stored patterns.
(
~keyboardResponder.();
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

//Task Definition to build stitches,  see examples/documentation for how to use
//dir1 and len1 = direction and length of modifier - 0 = normal, 1 = double
//dir2 and len2 "  "    "
//transform = value added to all values in pattern
//multiplier = multiplication performed on all values in pattern
//Parallel Tdefs can be created, which gives an interesting set of results.
(
~clearScreen.(30);
Tdef(\stitch,
	{ loop ({
		~loopPattern.(
			pattern:(0..33).choose,
			period:[0.01,0.01,0.01,0.01].choose,
			num:1,
			delay:10,
			transform:0,
			multiplier:1,
			dir1:(0..7).choose,
			len1:1
		);
		~sampleResponder.(
			freq:[400,500,600,700,50,60,70].choose,
			amp:0.1,
			atk:0.001,
			rel:0.01,
			pan:1,
			envMul:2
		);
	})}
)
)

Tdef(\stitch).play

(
Tdef(\stitchPar,
	{ loop ({
		~loopPattern.(
			pattern:(0..33).choose,
			period:0.01,
			num:1,
			delay:0.1,
			transform:0,
			multiplier:1,
		);
		~sampleResponder.(
			freq:(1..20).choose*100,
			amp:0.2,
			atk:0.01,
			rel:0.01,
			pan:0,
			envMul:2
		);
	})}
)
)

Tdef(\stitchPar).play

(
Tdef(\screen,
	{loop ({
		~clearScreen.(rrand(20,90));
			exprand(0.1,10).wait;
	})};
)
)

Tdef(\screen).clear

Tdef(\stitchPar).play;


//keyboard effects - default
(Ndef(\keyboardEffects,
	{
		var in = In.ar(4,2);
		in;
}););


~clearScreen.(90)

//sampler effects - default
(Ndef(\samplerEffects,
	{
		var in = In.ar(6,2);
		CombC.ar(RLPF.ar(in,SinOsc.kr(0.01).range(1000,3000),0.1),1,SinOsc.kr(0.1).range(0.1,1),10,0.9);
}););

~clearScreen.(70)

(
Tdef(\stitch2,
	{ loop ({
		~loopPattern.(
			pattern:[33,34].choose,
			period:0.05,
			num:1,
			delay:0.5,
			transform:0,
			multiplier:[1,2,3].choose,
		);
		~sampleResponder.(
			freq:500,
			amp:0.1,
			atk:0.01,
			rel:0.01,
			pan:0,
			envMul:2
		);
	})}
)
)



Tdef(\stitchPar).clear
Tdef(\stitch2).play


//scratchpad goes here:
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////







/*
////////////BREAK IN CASE OF EMERGENCY
BREAK IN CASE OF EMERGENCY
BREAK IN CASE OF EMERGENCY
BREAK IN CASE OF EMERGENCY

(
Tdef(\stitch,
	{ loop ({
		~loopPattern.(
			pattern:0,
			period:0.1,
			num:1,
			delay:0.5,
			transform:0,
			multiplier:1,
		);
		~sampleResponder.(
			freq:400,
			amp:0.1,
			atk:0.1,
			rel:0.01,
			pan:0,
			envMul:2
		);
	})}
)
)

(
Tdef(\stitchPar,
	{ loop ({
		~loopPattern.(
			pattern:0,
			period:0.1,
			num:1,
			delay:0.5,
			transform:0,
			multiplier:1,
		);
		~sampleResponder.(
			freq:400,
			amp:0.1,
			atk:0.1,
			rel:0.01,
			pan:0,
			envMul:2
		);
	})}
)
)

Tdef(\stitch).play;
Tdef(\stitchPar).play;


//keyboard effects - default
(Ndef(\keyboardEffects,
	{
		var in = In.ar(4,2);
		in;
}););


//sampler effects - default
(Ndef(\samplerEffects,
	{
		var in = In.ar(6,2);
		in;
}););


BREAK IN CASE OF EMERGENCY
BREAK IN CASE OF EMERGENCY
BREAK IN CASE OF EMERGENCY
BREAK IN CASE OF EMERGENCY
BREAK IN CASE OF EMERGENCY
*/
/////////////////


(
~clearScreen.(80);
Tdef(\stitch,
	{ loop ({
		~loopPattern.(
			pattern:2,
			period:0.01,
			num:1,
			delay:[0.5,0.5,0.25,0.1,0,0].choose ,
			transform:0,
			multiplier:1
		);
		~sampleResponder.(
			freq:400,
			amp:0.1,
			atk:0.01,
			rel:0.1,
			pan:1,
			envMul:2
		);
	})}
)
)
