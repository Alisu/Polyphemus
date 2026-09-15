The memory of a process, as a file.

A core dump is an ELF file whose program header table says, for each piece of the address space
that was written: where it lived, where its bytes are in the file, how many were written, and
how large the region was. Turning an address into a position in the file is the whole of it,
and it is the same arithmetic as finding an object in an image file -- one flat region there, a
list of mapped ones here.

Two things differ from an image and both matter. A dump has holes: a region can be larger than
what was written of it, and an address inside the unwritten part is absent rather than zero.
And nothing in a dump says where the object heap is; that is a separate question, answered
either from the VM's symbols or by the shape of the heap itself.

This class only reads the file. It does not know what a Spur object is.
