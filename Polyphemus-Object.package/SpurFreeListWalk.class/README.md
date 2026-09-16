What walking the free lists found: how many chunks they account for, how many bytes, and
everything about them that was wrong.

The point is the comparison. `SpurHeapWalk` counts the free space by stepping over every object
in the heap; this counts it by following the allocator's own lists. Two routes to the same
number, and a heap whose allocator is damaged is one where they disagree.
