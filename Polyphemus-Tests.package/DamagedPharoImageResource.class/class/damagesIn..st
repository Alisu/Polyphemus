building
damagesIn: aCleanReading

	"The words to overwrite, each as address -> word: Point's layout, Delay's class pool, the
	first class variable of Float, the method of the tenth context of the process resuming
	another, the list of the low space watcher."

	| slot point delay float pool entries resuming watcher |
	slot := [ :index :object | (DamagedCandleImage slot: index of: object) -> self taggedWord ].
	point := aCleanReading oopClassNamed: 'Point'.
	delay := aCleanReading oopClassNamed: 'Delay'.
	float := aCleanReading oopClassNamed: 'Float'.
	pool := (float oopSlotNamed: #classPool) oopSlotNamed: #array.
	entries := pool allReifiedSlots.
	resuming := self process: 'Process>>resume' in: aCleanReading.
	watcher := self process: 'SmalltalkImage>>lowSpaceWatcher' in: aCleanReading.
	^ {
		  (slot value: 4 value: point).
		  (slot value: (self indexOfSlotNamed: 'classPool' in: delay) value: delay).
		  (slot value: (entries indexOf: (entries detect: [ :each | each isNotNilOop ])) value: pool).
		  (slot
			   value: aCleanReading stacks contextMethodSlot
			   value: ((aCleanReading contextsOfProcess: resuming) at: 10)).
		  (slot value: aCleanReading processes processMyListSlot value: watcher) }
