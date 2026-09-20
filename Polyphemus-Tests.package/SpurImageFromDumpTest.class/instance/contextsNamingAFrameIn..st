helpers
contextsNamingAFrameIn: aRawHeap

	"Contexts whose sender is a frame pointer rather than a context: married in the dump,
	and nothing an image may hold."

	| scanner oop count contextClass |
	scanner := aRawHeap scanner.
	contextClass := self classIndexOfContextsIn: aRawHeap.
	oop := aRawHeap heapStart.
	count := 0.
	[ oop notNil and: [ oop < aRawHeap liveEnd ] ] whileTrue: [
		(((scanner headerAt: oop) bitAnd: 16r3FFFFF) = contextClass and: [
			 ((scanner slotOf: oop at: 1) bitAnd: 7) = 1 ]) ifTrue: [ count := count + 1 ].
		oop := scanner objectAfter: oop ].
	^ count
