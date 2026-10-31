Writes a core dump's heap out as an image file a VM starts, through VMMaker's own image writer: the header a dump never carried is built from the dumped VM's own variables, and its old space is described as the one segment an image holds.

What a running VM's snapshot does for itself is done here first: methods Cog compiled get their headers back, contexts married to frames are divorced from them, and the heap is collected, its free space at the end left out. SpurImageFromDumpTest starts what it writes with a real VM (docs/reading-a-dump.md, "Writing an image from a dump").

Not handled yet: an old space whose segments lie far apart, as VM 9's after it grew, is written as one segment from its start to its last segment's end, the gap included (#144).
