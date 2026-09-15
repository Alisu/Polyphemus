One piece of a dumped address space: where it was in the process, where its bytes are in the
file, and how much of it was actually written.

sizeInFile can be smaller than sizeInMemory. The region existed and the kernel did not write
all of it -- pages never touched, or deliberately left out. An address in that part is not zero
and not anything else: it is absent, and reading it has to say so.
