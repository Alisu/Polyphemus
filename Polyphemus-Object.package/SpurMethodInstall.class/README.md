Installs a method compiled in this image into another image's, in a new object of its own: rung 2 of #25, for a fix that does not fit where the old code sat. It finds what the new code names in the image, or makes it there -- strings, arrays, blocks, large integers, symbols interned in the image's own table -- and points the class's method dictionary at the new method.

What it writes goes into a SpurWritableMemory that can make objects and holds the image where the reading shows it: VMMaker's memory for an image file, or the process itself for a running image.
