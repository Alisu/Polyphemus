Bytes with addresses, for when the bytes are already in hand.

Answers the same few messages a core dump does -- whether an address is there, and the bytes or
the integer at one -- so that anything reading memory can read either without knowing which it
has. A dump is the real case; this is for tests, and for a region already lifted out of one.
