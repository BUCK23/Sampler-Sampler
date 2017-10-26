(
("../Language/language_1.9_Installation.scd").loadRelative;
~keyboardResponder.();
~sampleResponder.();
~hostPatternControl.();
)


~stitchHistory



(
Tdef(\stitch,
	{ loop ({
		~loopPattern.(
			pattern:0,
			period:0.5,
			num:1,
			delay:1,
			transform:0,
			multiplier:1,
		);
	})}
)
)

Tdef(\stitch).play

OSCFunc.trace

NetAddr.langPort

~stitchHistory