Finds a Spur heap in memory that does not say where one is.

A dump is regions of bytes; nothing in it knows what an object is. But a heap describes itself:
every object begins with an eight byte header whose slot count says where the next one starts.
Walk, and count how far you get. A Pharo heap walks for millions of objects; two megabytes of
noise managed two.

Reads through any address space that answers #hasAddress: and #unsignedAt:size: -- a core dump,
or a byte array with a base address. It never writes.

The header, 64 bits: class index in 0-21, format in 24-28, identity hash in 32-53, slot count in
56-63. A slot count of 255 means the real one is in the word before, whose own slot count byte is
also 255 -- which is how a forward walk tells an overflow word from a header.
