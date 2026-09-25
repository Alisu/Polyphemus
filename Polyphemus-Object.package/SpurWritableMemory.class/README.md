A Spur memory we write into: a copy of an image file's bytes, the memory VMMaker loaded a reading into, or a stopped process. One protocol for all three, in VMMaker's own words where it has them, so slots count from zero as the machine counts them. Reading an image is done elsewhere and never needs this.

A memory that #canMakeObjects also answers #allocateSlots:format:classIndex: and #floatOop:, which is what an installer needs; a copy of a file has nowhere to put a new object.
