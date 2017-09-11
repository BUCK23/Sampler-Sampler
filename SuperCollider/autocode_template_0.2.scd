// This file is the only file needed to operate the live coding language, with the relevant functions that comprise the language being loaded in the .loadRelative below

//Load microlanguage, note: only do this at the START of your session
(
	s.waitForBoot{{
	s.sync;
	~theFunc = {File("~/src/github/Sampler-Sampler/SuperCollider/savedStitches/stitches.txt".standardizePath,"r").readAllString.interpret};
	//this takes AGES to load
	s.sync;
	("Language/language_0.8.scd").loadRelative;
	~keyboardResponder.();
	~sampleResponder.();
	~hostPatternControl.();
	s.sync;
	StageLimiter.activate;
	s.sync;
	//These Ndefs are used to hold effects, which are constructed around the In.ar of each class
	(Ndef(\keyboardEffects,
		{
			var in = In.ar(4,2);
			in;
	}););
	// what are these
	Ndef(\keyboardEffects).play;
	Ndef(\keyboardEffects).fadeTime = 10;
	(Ndef(\samplerEffects,
		{
			var in = In.ar(6,2);
			in;
	}););
	Ndef(\samplerEffects).play;
	Ndef(\samplerEffects).fadeTime = 10;
	// what is this
	s.sync;
	(
		Tdef(\stitch,
			{ loop ({
				~loopPattern.(
					pattern:0,
					period:0.5,
					num:1,
					delay:5,
					transform:0,
					multiplier:1,
				);
				~sampleResponder.(
					freq:400,
					amp:0.1,
					atk:0.01,
					rel:0.5,
					pan:0,
					envMul:2
				);
			})}
		)
	);
	s.sync;
	//this optin is available for preloading a pattern library already held within the machine.
	//~stitchHistory = ~theFunc.();
	(
		Tdef(\stitchClearer,
			{ loop ({
			//code about the list generator goes here
			})
			}
		)
	)
	s.sync;
	Tdef(\stitch).play;
	"done".postln;
	}.fork;}
)