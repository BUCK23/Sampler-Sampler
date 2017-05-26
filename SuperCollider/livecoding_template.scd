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

//Task Definition to build stitches,  see examples/documentation for how to use
(
Tdef(\stitch,
	{ loop ({
		~loopPattern.(
			pattern:0,
			period:0.1,
			num:1,
			delay:0.5,
			modifier1:"NONE",
			modifier2:"NONE",
			modifier3:"NONE",
			modifier4:"NONE",
		);
		~sampleResponder.(
			freq:400,
			amp:0.1,
			atk:0.01,
			rel:0.01,
			pan:0,
			envMul:2
		);
	})}
)
)

Tdef(\stitch).play;

//scratchpad goes here:


(
Tdef(\stitch,
	{ loop ({
		~loopPattern.(
			pattern:0,
			period:0.01,
			num:1,
			delay:0.01,
			transform:[0,0,0,0,0,0,0,0,0,0,0,1,-1,-6].choose,
			modifier1:"NONE",
			modifier2:"NONE",
			modifier3:"NONE",
			modifier4:"NONE",
		);
		~sampleResponder.(
			freq:rrand(100,401),
			amp:0.1,
			atk:0.01,
			rel:0.5,
			pan:rrand(-1,1),
			envMul:2
		);
	})}
)
)

Tdef(\stitch).play

~clearScreen.(20)

OSCFunc.tracefer