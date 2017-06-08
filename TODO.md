# TODO list for refactoring sampler/sampler 1.0

- Change the pattern logic from a Tdef to a Pbind
    - Is this possible? Yes. A Pfunc can contain the `~loopPattern` function, so it should also be able to iterate through these patterns.
    - This would solve a lot of issues around the scheduling of patterns, and would allow for the setting of pattern playback by using Pbind's built in `dur` values
    - Any possible problems? 
        - It would be a hack but that's not necessarily the worst thing in the world
        - Would require re-writing of the functions that control pattern playback
^^^^ I tried this, and it wasn't great, as it presents the issue of how to do the kinds of play pattern (1, 5, 2, 6) thing, and a SynthDef won't take it. I'm not sure how to sort this, maybe with a bunch of transformations? creating new arrays maybe?

- Update the template file to have a bunch of iteration tools in it so that I can play with compound patterns
    - a possibility for this is to create a 3-dimensional array, [0][0][i] is the first subpattern of the first pattern.
    - when an empty pattern is sent, this will collect all of the current subpatterns and make them into a metapattern?
    - StitchHistory -> [ Pattern Number [ Pattern Index [ dir, len ] ] ]
    -

- Make the sonification better
    - Could have a number of different 'instruments' through which to filter the sonification: Drums, sines
    - The currently existing sonification patterns can just be a bunch of functions with different arguments passed to them rather than being hard coded (which is silly)
