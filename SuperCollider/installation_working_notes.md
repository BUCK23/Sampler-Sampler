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

Both done, although the 'time' of patterns is not the best.

## Get a more efficient autocoding setup, which is a bit more interesting or dynamic than simple randomness

- In order to do this i'm first going to need to figure out a schema for making things more interesting.
- Toni sent me this paper about blackwork embroidery and maths and that might be a place to look first
- L-systems are a possiblity just to get something more organic, and rules would be easy enough to auto-generate

## Get an 'autocode' setting on a transparent overlay

## Make a shell script that will open SCSynth, start up the .scd file, then open up the Processing sketch.

a simple 'sclang file.scd' doesn't work, it just jams and says that waitForBoot is not actually working

It's to do with DDWSnippets and the document class, I need to remove DDWSnippets while i'm going to be working with sampler/sampler

Then it 'just works'
