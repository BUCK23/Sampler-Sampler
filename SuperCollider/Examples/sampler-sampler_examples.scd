//Load microlanguage, note: only do this at the START of your session
(
("../Language/language_0.4.scd").loadRelative;
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


//draw and save a few patterns in processing before continuing

//Basic Tdef, repeating the same pattern over and over
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
	})}
)
)



//Repeats the pattern once then chooses another pattern (from 0-3)
(
Tdef(\stitch,
	{ loop ({
		~loopPattern.(
			pattern:[0,1,2,3].choose,
			period:0.1,
			num:1,
			delay:0.5,
			modifier1:"NONE",
			modifier2:"NONE",
			modifier3:"NONE",
			modifier4:"NONE",
			reverse:0,
		);
	})}
)
)

//Repeats the pattern and jumps in a random direction, no wait time between patterns
(
Tdef(\stitch,
	{ loop ({
		~loopPattern.(
			pattern:0,
			period:0.1,
			num:1,
			delay:0,
			modifier1:~randDir.(),
			modifier2:"NONE",
			modifier3:"NONE",
			modifier4:"NONE",
			reverse:0,
		);
	})}
)
)

//Picks a pattern from 0-3, a period from 0.01-0.1 and a delay between 0 and 1
(
Tdef(\stitch,
	{ loop ({
		~loopPattern.(
			pattern:[0,1,2,3].choose,
			period:rrand(0.01,0.1),
			num:1,
			delay:rrand(0,1.0),
			modifier1:~randDirLong.(),
			modifier2:"NONE",
			modifier3:"NONE",
			modifier4:"NONE",
			reverse:0,
		);
	})};
)
)


//as above, but once the pattern has been run once, choose a new frequency for the sonification
(
Tdef(\stitch,
	{ loop ({
		~loopPattern.(
			pattern:[0,1,2,3].choose,
			period:rrand(0.01,0.1),
			num:1,
			delay:rrand(0,1.0),
			modifier1:~randDirLong.(),
			modifier2:"NONE",
			modifier3:"NONE",
			modifier4:"NONE",
			reverse:0,
		);
		~sampleResponder.(
			freq:rrand(100,1000).round(100),
			amp:0.1,
			atk:0.01,
			rel:0.1,
			pan:0,
			envMul:2
		);
	})};
)
)



//as above, but run the pattern ten times, then reset the grid with a random scale
(
Tdef(\stitch,
	{ loop ({
		~loopPattern.(
			pattern:[0,1,2,3].choose,
			period:rrand(0.01,0.1),
			num:10,
			delay:rrand(0,1.0),
			modifier1:~randDirLong.(),
			modifier2:"NONE",
			modifier3:"NONE",
			modifier4:"NONE",
			reverse:0,
		);
		~sampleResponder.(
			freq:rrand(100,1000).round(100),
			amp:0.1,
			atk:0.01,
			rel:0.1,
			pan:0,
			envMul:2
		);
		~clearScreen.(rrand(10,80));
	})};
)
)


//as above, but with more random things in it and faster
(
Tdef(\stitch,
	{ loop ({
		~loopPattern.(
			pattern:[0,1,2,3].choose,
			period:rrand(0.001,0.04),
			num:rrand(1,4),
			delay:rrand(0,0.1),
			modifier1:~randDirLong.(),
			modifier2:~randDir.(),
			modifier3:"NONE",
			modifier4:"NONE",
			reverse:0,
		);
		~sampleResponder.(
			freq:rrand(100,1000).round(100),
			amp:rrand(0.1,0.5),
			atk:rrand(0,0.02),
			rel:rrand(0.01,0.5),
			pan:0,
			envMul:2
		);
		~clearScreen.(rrand(10,80));
	})};
)
)