damages
damagesOfAProcessIn: aCleanReading

	"In the low space watcher, whose list is already a tagged word: its priority pointing at the
	process itself, and its name zeroed, which points nowhere once loaded (#118)."

	| watcher nameSlot |
	watcher := self process: 'SmalltalkImage>>lowSpaceWatcher' in: aCleanReading.
	nameSlot := watcher oopClass allInstVarNames indexOf: 'name'.
	^ {
		  ((DamagedCandleImage slot: aCleanReading processes processPrioritySlot of: watcher)
		   -> [ :distance | watcher address - distance ]).
		  ((DamagedCandleImage slot: nameSlot of: watcher) -> 0) }
