// This file is the only file needed to operate the live coding language, with the relevant functions that comprise the language being loaded in the .loadRelative below

//Load microlanguage, note: only do this at the START of your session
(
s.waitForBoot({
("Language/language_0.6.scd").loadRelative;
~keyboardResponder.();
~sampleResponder.();
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
});
)

//if you hard stop SCLang, run this block to get functionality back, or you will lose stored patterns.
(
~keyboardResponder.();
~sampleResponder.();
~hostPatternControl.();
)

//a way to load patterns dry
~stitchHistory = File("~/src/github/Sampler-Sampler/SuperCollider/savedStitches/stitches.txt".standardizePath,"r").readAllString.interpret



//Task Definition to build stitches,  see examples/documentation for how to use
//dir1 and len1 = direction and length of modifier - 0 = normal, 1 = double
//dir2 and len2 "  "    "
//transform = value added to all values in pattern
//multiplier = multiplication performed on all values in pattern
//Parallel Tdefs can be created, which gives an interesting set of results.
(
~clearScreen.(80);
Tdef(\stitch,
	{ loop ({
		~loopPattern.(
			pattern:[0,0,8].choose,
			period:0.1/5,
			num:1,
			delay:1,
			transform:0,
			multiplier:1,
			dir1:(0..3).choose,
			len1:1
		);
		~sampleResponder.(
			freq:{[8000,100,400,3000].choose}!2,
			amp:0.1,
			atk:0.01,
			rel:0.1,
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
			pattern:2,
			period:0.1/10,
			num:1,
			delay:[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1].choose,
			transform:0,
			multiplier:1,
			dir1:(0..7).choose,
			len1:1
		);
		~sampleResponder.(
			freq:[80,90,100,110,130].choose,
			amp:0.1,
			atk:0.05,
			rel:0.05,
			pan:0,
			envMul:2
		);
	})}
)
)

Tdef(\stitchPar).play;
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
		RLPF.ar(in,SinOsc.kr(0.05).range(80,5000),0.1);
}););

(
Tdef(\screen,{
	loop{~clearScreen.(rrand(15,30));
		exprand(0.001,50).wait;
}})
)
Tdef(\screen).play
//scratchpad goes here:
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////

(
Tdef(\stitch,
	{ loop ({
		~loopPattern.(
			pattern:8,
			period:0.1,
			num:1,
			delay:0,
			transform:0,
			multiplier:1,
			dir1:(0..7).choose,
			len1:0
		);
		~sampleResponder.(
			freq:[400,2000,3000,100,200,300,3000,4000,5000].choose,
			amp:0.4,
			atk:0.01,
			rel:0.2,
			pan:0,
			envMul:2
		);
	})}
)
)

Tdef(\stitch).play

//2


(
Tdef(\stitchPar,
	{ loop ({
		~loopPattern.(
			pattern:9,
			period:0.1,
			num:1,
			delay:0.1,
			transform:[0,4,2,3].choose,
			multiplier:1,
			dir1:(0..7).choose,
			len1:1
		);
		~sampleResponder.(
			freq:(1..10).choose*1000,
			amp:0.4,
			atk:0.01,
			rel:0.01,
			pan:0,
			envMul:2
		);
	})}
)
)

Tdef(\stitch).stop

Tdef(\stitchPar).play

(Ndef(\samplerEffects,
	{
		In.ar(6,2)
}););


Ndef(\samplerEffects).fadeTime = 5

Ndef(\samplerEffects).play

Ndef(\samplerEffects).clear

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


Ndef(\samplerEffects).play

(Ndef(\samplerEffects,
	{
		var in = In.ar(6,2);
		CombC.ar(in,1,0.4,3)
}););
