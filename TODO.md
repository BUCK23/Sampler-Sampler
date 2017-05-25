# TODO list for refactoring sampler/sampler 1.0

- turn array of directions into array of numbers and have that recognised at both ends - DONE

issues:
- parsing of directions on the processing side from SuperCollider is done by using an `if string.equals()` function, this will need be to be done as an int. should ve fine.

- DIRECTIONS:
- 0 = UP
- 1 = UPRIGHT
- 2 = RIGHT
- 3 = DOWNRIGHT
- 4 = DOWN
- 5 = DOWNLEFT
- 6 = LEFT
- 7 = UPLEFT

Then transformations could be performed on these by using a %7?

The issue is with Long directions, is the best thing to do to use another modifier string/int, and send as an OSC array. There's no reason why this wouldn't make sense, as it would make 'long-ifying' the individual stitches a lot easier.

- LONG DIRECTIONS:
- 0 1 = UPLONG
- 1 1 = UPRIGHTLONG
- 2 1 = RIGHTLONG
- 3 1 = DOWNRIGHTLONG
- 4 1 = DOWNLONG
- 5 1 = DOWNLEFTLONG
- 6 1 = LEFTLONG
- 7 1 = UPLEFTLONG


- eliminate the need for two processing files - this has been done using the `mode` variable in the initialisation part of the processing sketch - DONE
