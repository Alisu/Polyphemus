A frame that says it is running machine code, so that the refusal can be tested.

Reading a real one needs a Cog stack page out of a dump, which stage two cannot do yet -- stack
pages live in the virtual machine's own C memory rather than in the object heap. What can be
tested now is the part that matters most: that such a frame refuses to be read with the stack
interpreter's offsets rather than answering something for every question.
