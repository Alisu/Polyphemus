Writes a core dump's heap out as an image file, through VMMaker's own image writer: the header a dump never carried is built from the dumped VM's own variables, and its old space is described as the one segment an image holds.

What it writes is the heap as the dump has it. Not yet done, and each its own pass: methods Cog compiled still hold their CogMethod where their header belongs, contexts married to frames still name those frames, and new space is not in it. So the file reads with our own readers; it is not a snapshot a VM can start.
