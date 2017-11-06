//PRIMITIVE AUTORUN CODE WORKING AT 9.30AM 4TH NOVEMBER 2017
// This file is the only file needed to operate the live coding language, with the relevant functions that comprise the language being loaded in the .loadRelative below

//Load microlanguage, note: only do this at the START of your session

//THIS DOESN'T WORK. WHY?s
//for some reason Processing is receiving ints rather than floats. Don't know why this is but i'll fix it.
(
var time = rrand(0.01,0.5) / 2, delay = rrand(0,3.0) / 2, repetitions = [1,1,1,1,1,1,2,3,4,5,6].choose;
s.waitForBoot{{

	10.wait;
	//4th October: load new lang
	("Language/language_1.9_1_Installation.scd").loadRelative;

	10.wait;
	//recall stitches
	~stitchHistory = File("savedStitches/stitches_install.txt".resolveRelative,"r").readAllString.interpret;

	10.wait;

	//stitch Tdef
	//This needs to handle stitch removal on some kind of iteration, just so that we don't get an edge case where a stitch is removed during play, and then we get an error, although seeing as this is a Tdef it might not actually matter too much.
	(
		Tdef(\stitch,
			{ loop ({
				var time = rrand(0.01,0.5) / 2, delay = rrand(0,3.0) / 2, repetitions = [1,1,1,1,1,1,2,3,4,5,6].choose;

				~loopPattern.(
					pattern:rrand(0,~stitchHistory.size-1),
					period:time,
					num:repetitions,
					delay:delay,
					transform:0,
					multiplier:1,
				);
			})}
		)
	);
	10.wait;
	//TODO: Implement this so that it is restarted when the first index of ~stitchHistory is filled up
	(
		Tdef(\sampleCleaner,
			{ loop ({
				if(~stitchHistory[0] != nil,
					{
						(60 - ~stitchHistory.size).wait;
						//if the array is empty

						~stitchHistory.removeAt(0);
						"Oldest pattern removed!".postln;
					},{
						10.wait;
					}
				);
			})}
		)
	);
	10.wait;

	"done".postln;

	//THIS WORKS!
	Tdef(\stitch).play;
	Tdef(\sampleCleaner).play;

}.fork;}
)