private
activeProcessPriority

	"The priority of the process running this moment; nil when its slot holds no SmallInteger.
	Call it stopped."

	| word |
	word := (SpurHeapScanner on: reader) slotOf: self activeProcessAddress at: 3.
	^ (word bitAnd: 7) = 1 ifTrue: [ word bitShift: -3 ]
