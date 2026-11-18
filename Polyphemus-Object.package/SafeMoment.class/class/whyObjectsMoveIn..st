the collector
whyObjectsMoveIn: someVMVariables

	"Why its heap may not read whole: a scavenge or a compaction moving objects. nil when neither;
	objects being marked read whole, and do not count here."

	| phase |
	phase := someVMVariables at: 'gcPhaseInProgress'.
	^ phase = 0 ifFalse: [ 'collecting garbage (gcPhaseInProgress ' , phase printString , ')' ]
