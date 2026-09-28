helpers
flagIn: aSession

	"Reached as in an inspector, through the block given it: on the stack wherever the target was
	held, in do: or on its loop's own backward jump. A block of a script has no temporary names,
	but its temporaries read, and the flag is the one Array among the blocks' first ones."

	^ (aSession interruptedContext findContextSuchThat: [ :each |
		   each isBlockContext and: [ (each tempAt: 1) oopClass name = #Array ] ]) tempAt: 1
