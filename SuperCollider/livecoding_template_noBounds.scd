// This file is the only file needed to operate the live coding language, with the relevant functions that comprise the language being loaded in the .loadRelative below

//Load microlanguage, note: only do this at the START of your session
(
("Language/language_0.8.scd").loadRelative;
~keyboardResponder.(pan:-1);
~sampleResponder.(pan:1);
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
~keyboardResponder.(pan:-1);
~sampleResponder.(pan:1);
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
			atk:0.01,
			rel:0.5,
			pan:1,
			envMul:2
		);
	})}
)
)

Tdef(\stitch).play;


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

~clearScreen.(20)

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