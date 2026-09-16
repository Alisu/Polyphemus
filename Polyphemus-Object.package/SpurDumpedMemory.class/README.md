The memory of a virtual machine that is no longer running, presented as one VMMaker
memory manager.

A dump says nothing about itself: where the heap is, and which object is the special
objects array, are found by shape and by contents (`SpurHeapScanner`). What is left is to
hand that to VMMaker in the form it expects, which is what this does -- so everything
stage one can do to an image file applies to a dead process.

The one thing a dump does not carry is how full eden was, so new space is given its
geometry and declared empty. See `#setUpNewSpaceOf:`.
