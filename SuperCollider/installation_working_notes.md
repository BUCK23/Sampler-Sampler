# Installation working notes, week 11th-15th Sept

I NEED TO:

## Get SuperCollider to run startup code efficiently

- This took a lot of tinkering to get s.sync to work
- In order for s.sync to work while the server boots, it needs to be placed WITHIN an s.waitForBoot:
(
s.waitForBoot{{
~stuff.do;
s.sync;
~moreStuff.do;
}.fork;
}
)
- This places s.sync within a routine so that it can be evaluted properly, and this means that the server does not need any hard-coded wait times in order to get things done.

## Handle the installation-based setup for this work.

This needs the following:
- A removal of old patterns so that people can actually see the patterns that they make be uploaded to the installation

I suspect this will need to be done in a task that loops, and with each loop it removes an element of the array. When the array will be at 0 patterns it simply clears the list rather than deleting everything because this may cause some potential issues and maybe crash stuff(?)

- I tested this, look at listTester.scd - this will then be implemented as a Tdef. This Tdef will remove a pattern every minute.
Maybe a minute is not the best interval, because if there is loads of patterns then it will just take ages for the patterns to clear, especially if people are spamming the thing with patterns.
Maybe:
- Time patterns are allowed to remain is made more dynamic
- A 'Max number' of patterns added to the function to prevent silly spamming while making sure that patterns don't disappear too quickly.

## Get a more efficient autocoding setup, which is a bit more interesting or dynamic than simple randomness

## Get an 'autocode' setting on a transparent overlay

## Make a shell script that will open SCSynth, start up the .scd file, then open up the Processing sketch.