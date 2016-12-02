("language_0.4.scd").loadRelative

/*

Language Parameters

~dir = single step directions
~dirLong = dual-step directions
~clearScreen.(scaling)
~randDir.()
~randDirLong.()


*/


(
~keyboardResponder.(amp:0.1, pan:0.8, envMul:3);
~sampleResponder.(amp: 0.1, pan:-0.8,envMul:1.5);
~hostPatternControl.();
)

(
Tdef(\stitch,
	{ loop ({
		~loopPattern.(
			pattern:[13,14,15,1,2,3,4].choose,
			period:0.001,
				num:rrand(1,10),
			delay:0,
			modifier1:~dir.choose,
			modifier2:~dir.choose,
			modifier3:~dir.choose,
			modifier4:"NONE",
			reverse:0,
		);
		~sampleResponder.(
			freq:[400,800,1600,100,500,1900,1200,1500].choose,
			amp:0.01,
			atk:0.01,
			rel:[0.01,0.04,0.1].choose,
			pan:-0.8,
			envMul:2
		);
	})}
)
)

~clearScreen.(90);

Tdef(\stitch).play

