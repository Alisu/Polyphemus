writing
allocateContextOf: slots like: aFrame

	"A context of this memory's own kind, past the last object, where the memory allocates
	next. Not through VMMaker's own allocator: that keeps a free tree a dump's does not
	satisfy (its totalFreeOldSpace is not even set). The collection pass rebuilds free space."

	| memory address likeness |
	memory := dumped memory.
	likeness := dumped raw scanner headerAt: self aContextOfThisMemory.
	address := memory freeOldSpaceStart.
	memory setFreeOldSpaceStart: address + memory baseHeaderSize + (slots * memory wordSize).
	memory
		longAt: address
		put: (likeness bitAnd: 16r00FFFFFF00FFFFFF) + (slots bitShift: 56).
	0 to: slots - 1 do: [ :each |
		memory storePointerUnchecked: each ofObject: address withValue: memory nilObject ].
	^ address
