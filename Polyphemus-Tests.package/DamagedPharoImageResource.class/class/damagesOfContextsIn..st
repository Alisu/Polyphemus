building
damagesOfContextsIn: aCleanReading

	"On four stacks no other damage is on, a context's own slots: zeroed, so that they point
	nowhere once loaded, or pointing at an object that is no context and no integer."

	| stacks zeroed pointing worker finalising drawing snapshotting |
	stacks := aCleanReading stacks.
	zeroed := [ :index :context | (DamagedCandleImage slot: index of: context) -> 0 ].
	pointing := [ :index :context :object |
	            (DamagedCandleImage slot: index of: context) -> [ :distance | object address - distance ] ].
	worker := self contextsOf: 'AtomicSharedQueue>>waitForNewItems' in: aCleanReading.
	finalising := self contextsOf: 'WeakArray class>>finalizationProcess' in: aCleanReading.
	drawing := self contextsOf: 'MorphicRenderLoop>>doOneCycleWhile:' in: aCleanReading.
	snapshotting := self contextsOf: 'SessionManager>>launchSnapshot:andQuit:' in: aCleanReading.
	^ {
		  (zeroed value: stacks contextReceiverSlot value: (worker at: 3)).
		  ((DamagedCandleImage slot: stacks closureOuterContextSlot of: (worker at: 4) closureOrNil) -> self taggedWord).
		  (pointing value: stacks contextSenderSlot value: (worker at: 8) value: (worker at: 8) receiver).
		  (zeroed value: stacks contextMethodSlot value: (finalising at: 2)).
		  (zeroed value: stacks contextSenderSlot value: drawing first).
		  (zeroed value: stacks contextPcSlot value: (snapshotting at: 2)).
		  (pointing value: stacks contextStackPointerSlot value: snapshotting first value: snapshotting first receiver) }
