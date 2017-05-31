// This file is the only file needed to operate the live coding language, with the relevant functions that comprise the language being loaded in the .loadRelative below

//Load microlanguage, note: only do this at the START of your session
(
("Language/language_0.5_Experimental.scd").loadRelative;
~keyboardResponder.();
~sampleResponder.();
~hostPatternControl.();
//OPTIONAL: StageLimiter, depends on BatLib Quark
//StageLimiter.activate
)

//if you hard stop SCLang, run this block to get functionality back, or you will lose stored patterns.
(
~keyboardResponder.();
~sampleResponder.();
~hostPatternControl.();
)

~keyboardResponder.(80)

//Task Definition to build stitches,  see examples/documentation for how to use
//dir1 and len1 = direction and length of modifier - 0 = normal, 1 = double
//dir2 and len2 "  "    "
//transform = value added to all values in pattern
//multiplier = multiplication performed on all values in pattern
(
Tdef(\stitch,
	{ loop ({
		~loopPattern.(
			pattern:1,
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

//scratchpad goes here:
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////



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