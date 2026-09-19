A dump or a live process turned into a VMMaker memory, so that everything stage one does to an
image file works on it: reified memory, processes, stacks, the debugger.

The finding and checking is `SpurRawHeap`'s (`#raw`); this class puts those bytes back at their
own addresses in the simulator and sets the registers an image header would have supplied.
