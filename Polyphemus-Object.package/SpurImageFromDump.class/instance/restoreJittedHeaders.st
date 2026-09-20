writing
restoreJittedHeaders

	"Cog keeps a jitted method's header in its CogMethod and leaves the CogMethod's address
	where the header was. Put each one back, as CogMethodZone>>freeMethod: does at snapshot,
	and only where that CogMethod points back at the method (#3). Answers how many."

	| scanner oop layout restored |
	scanner := dumped raw scanner.
	layout := OOPCogLayout on: (LazyReifiedMemory on: dumped memory) raw: dumped raw.
	oop := dumped raw heapStart.
	restored := 0.
	[ oop notNil and: [ oop < dumped raw liveEnd ] ] whileTrue: [
		((scanner formatIn: (scanner headerAt: oop)) >= 24 and: [
			 ((scanner slotOf: oop at: 1) bitAnd: 7) ~= 1 ]) ifTrue: [
			dumped memory
				storePointerUnchecked: 0
				ofObject: oop
				withValue: (layout methodHeaderOf: oop).
			restored := restored + 1 ].
		oop := scanner objectAfter: oop ].
	^ restored
