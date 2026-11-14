building
damagesOfObjectsIn: aCleanReading

	"In unrelated objects: two classes, a class variable, a process, and on two stacks a context's
	method, two methods' trailers and a literal zeroed so that it points nowhere once loaded."

	| slot point delay float pool entries resuming watcher |
	slot := [ :index :object | (DamagedCandleImage slot: index of: object) -> self taggedWord ].
	point := aCleanReading oopClassNamed: 'Point'.
	delay := aCleanReading oopClassNamed: 'Delay'.
	float := aCleanReading oopClassNamed: 'Float'.
	pool := (float oopSlotNamed: #classPool) oopSlotNamed: #array.
	entries := pool allReifiedSlots.
	resuming := aCleanReading contextsOfProcess: (self process: 'Process>>resume' in: aCleanReading).
	watcher := self process: 'SmalltalkImage>>lowSpaceWatcher' in: aCleanReading.
	self assert: ((self methodsWithDamagedTrailersIn: resuming) collect: [ :each | each address ]) asSet size = 2.
	^ {
		  (slot value: 4 value: point).
		  (slot value: (self indexOfSlotNamed: 'classPool' in: delay) value: delay).
		  (slot value: (entries indexOf: (entries detect: [ :each | each isNotNilOop ])) value: pool).
		  (slot value: aCleanReading stacks contextMethodSlot value: (resuming at: 10)).
		  (slot value: aCleanReading processes processMyListSlot value: watcher).
		  ((self endOf: (self methodsWithDamagedTrailersIn: resuming) first in: aCleanReading) - 4
		   -> #[ 255 255 255 255 ]).
		  ((self endOf: (self methodsWithDamagedTrailersIn: resuming) last in: aCleanReading) - 5
		   -> #[ 255 255 255 127 47 ]).
		  ((DamagedCandleImage slot: 2 of: (self methodWithBlocksIn: aCleanReading)) -> 0) }
