// This file is the only file needed to operate the live coding language, with the relevant functions that comprise the language being loaded in the .loadRelative below

("Language/language_0.4.scd").loadRelative

/*

Language Parameters

~dir = single step directions
~dirLong = dual-step directions
~clearScreen.(scaling)
~randDir.()
~randDirLong.()


*/


//DON'T FORGET TO RECORD!!!!

(
~keyboardResponder.(amp:0.1, pan:0.8, envMul:3);
~sampleResponder.(amp: 0.1, pan:-0.8,envMul:1.5);
~hostPatternControl.();
)

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
			pan:-0.8,
			envMul:2
		);
	})}
)
)

