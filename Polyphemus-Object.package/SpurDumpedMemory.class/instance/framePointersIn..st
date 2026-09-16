frames
framePointersIn: aReifiedMemory

	"Where this dump's stack frames are, found from the heap.

	Stack pages are the virtual machine's own C memory, not the object heap, and nothing in a
	dump says where they are. But a *married* context keeps its frame pointer where a sender
	would be, and married contexts are ordinary objects in the heap we can already read. So
	the heap tells us where the frames are.

	Each one is believed only if the frame points back: the word two below the frame pointer
	is the frame's context, and it has to be the context we came from. That is the same kind
	of mutual reference that confirms the special objects array -- one side can be a
	coincidence, both cannot.

	Measured on a real core: 94 contexts named a frame and 43 were confirmed this way. The
	rest are contexts whose frame is long gone, which is what a divorced context looks like
	from here."

	| found |
	found := OrderedCollection new.
	aReifiedMemory do: [ :each |
		[
		| sender fp |
		sender := aReifiedMemory simulator fetchPointer: 0 ofObject: each address.
		(sender > 0 and: [
			 sender < mappingStart or: [ sender >= mappingLimit ] ]) ifTrue: [
			fp := sender - 1.
			(self spaceHolding: fp) ifNotNil: [
				(self wordOfFrame: fp at: -16) = each address ifTrue: [ found add: fp ] ] ] ]
			on: Error
			do: [ :e | nil ] ].
	^ found
