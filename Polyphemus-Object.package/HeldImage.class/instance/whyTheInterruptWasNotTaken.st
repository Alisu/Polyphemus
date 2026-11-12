private
whyTheInterruptWasNotTaken

	"What the watcher's semaphore and the VM's requests for it say, for a hold not taken: whether
	the signal is still the VM's to give, was given to nobody, or found the watcher elsewhere (#137)."

	^ [
	  reader whileStopped: [
		  | writable variables slot semaphore request nilOop first |
		  writable := SpurWritableProcess on: reader.
		  variables := writable variables.
		  slot := self semaphoreIndex - 1.
		  semaphore := writable
			               fetchPointer: slot
			               ofObject: (writable fetchPointer: 38 ofObject: (variables at: 'specialObjectsOop')).
		  first := writable fetchPointer: 0 ofObject: semaphore.
		  nilOop := [ variables at: 'nilObj' ] on: Error do: [ :error | nil ].
		  request := (variables at: 'signalRequests') + (slot * 8).
		  ' (its semaphore counts ' , ((writable fetchPointer: 2 ofObject: semaphore) bitShift: -3) printString , ' signals, '
		  , (first = nilOop ifTrue: [ 'no process waits on it' ] ifFalse: [ 'a process waits on it' ]) , '; the VM has '
		  , (writable int32At: request) printString , ' requests and ' , (writable int32At: request + 4) printString
		  , ' responses for it, checkSignalRequests '
		  , (writable int32At: (variables addressOf: 'checkSignalRequests')) printString , ', tides A '
		  , (writable int32At: (variables addressOf: 'lowTideA')) printString , ' to '
		  , (writable int32At: (variables addressOf: 'highTideA')) printString , ' and B '
		  , (writable int32At: (variables addressOf: 'lowTideB')) printString , ' to '
		  , (writable int32At: (variables addressOf: 'highTideB')) printString , ', using '
		  , ((writable bytesAt: (variables addressOf: 'useTideA') count: 1) first = 0 ifTrue: [ 'B' ] ifFalse: [ 'A' ])
		  , '; a process at priority ' , self activeProcessPriority printString , ' has the processor)' ] ]
		  on: Error
		  do: [ :error | ' (its state could not be read: ' , error messageText asString , ')' ]
