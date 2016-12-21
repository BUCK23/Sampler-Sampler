// This file is the only file needed to operate the live coding language, with the relevant functions that comprise the language being loaded in the .loadRelative below

//Load microlanguage, note: only do this at the START of your session
(
("Language/language_0.4.scd").loadRelative;
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
			reverse:0,
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