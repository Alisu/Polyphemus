A compiled method seen as its raw bytes, so that Pharo CompiledMethodTrailer can
decode the trailer of a method living in another image.

It exists because #at: on a reified method means the bytecode at a pc, which is what
the bytecode tools expect, while the trailer decoder counts bytes from the end of the
whole object.
