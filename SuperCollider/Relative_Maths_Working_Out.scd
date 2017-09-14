
OSCFunc.trace(false)

for
~stitchHistory
~stitchHistory = List.new
~stitchHistory[0][0][0]

~workingStitch = ~stitchHistory[0]
~workingStitch2 = List.new
~workingStitchFlopped = ~workingStitch.flop
~workingStitch2.add(List.new)

~workingStitch[0][0]

//This does it to TWO degrees
(
for (0, 3,
	{ arg i;
		for (0, ~workingStitchFlopped[i].size-1,
			{ arg j;
				~workingStitch2[i].add(~workingStitchFlopped[i][j] - ~workingStitchFlopped[i][0])
		});
		~workingStitch2.add(List.new)
})
)
~workingStitch2.flop


//the next one does it to three degrees but i can't work out how but that's fine.

~stitchHistory

~stitchHistoryFlopped = ~stitchHistory.flop

~newStitchHistoryFlopped = List.new
~newStitchHistoryFlopped.add(List.new)
~newStitchHistoryFlopped[0][0].add(List.new)

//this doesn't make sense
// i also cannot make it work.
(
for(0, ~stitchHistoryFlopped.size-1,
	{arg h;
		"h = ".post;
		h.postln;
		for (0, ~stitchHistoryFlopped[h].size-1,
			{ arg i;
				"i = ".post;
				i.postln;
				for (0, 3,
					{ arg j;
						"j = ".post;
						j.postln;
						~newStitchHistoryFlopped[h][i].add(~stitchHistoryFlopped[h][i][j] - ~stitchHistoryFlopped[h][i][0]);
				});
				~newStitchHistoryFlopped[h].add(List.new);
		});
		~newStitchHistoryFlopped.add(List.new);
	}
)
)


~stitchHistoryFlopped[0][0].removeAt(~stitchHistoryFlopped[0][0].size-1)

~newStitchHistoryFlopped = 0
~newStitchHistoryFlopped

~stitchHistory

~newstitchHistoryFlopped

~workingStitchFlopped[4][4]

,~workingStitch2

~workingStitch2[0].clear
~workingStitch2[0].add(~workingStitchFlopped[0][0])


/*
//DIRECTIONS:

1. Flop the array
2. Make new list
3. Iterate

*/