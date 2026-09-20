accessing
writtenFrom: aDumpedMemory

	"The dump written out as an image file, once for the class. What the dump held is counted
	first: writing it changes the memory the fixture shares -- frames become contexts in it."

	^ Written ifNil: [
		  Stacks := self stacksOf: StackOfADumpTest memory.
		  Written := (SpurImageFromDump on: aDumpedMemory) writeTo:
			             FileLocator temp / 'polyphemus-from-dump.image' ]
