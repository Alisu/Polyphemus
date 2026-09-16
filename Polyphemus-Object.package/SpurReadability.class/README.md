How much of this memory can honestly be read, and what stops it going further.

Reading an image is not one thing that works or fails. It is a ladder: bytes, then a heap, then
objects, then the free space, then classes, then the special objects. Each rung needs the one
below it, and each can be damaged on its own -- a heap whose class table is broken still has
perfectly good objects in it, they just have no names.

So every question declares the rung it needs, and a question asked above the highest readable
rung raises `SpurCannotRead` instead of answering. That is the whole point: this tool exists for
images that are damaged, so the case where it cannot read is not an edge case, it is the case.

What is not checked here is the rung above: source. A method's trailer and the `.sources` file
are per-method questions, answered where they are asked.
