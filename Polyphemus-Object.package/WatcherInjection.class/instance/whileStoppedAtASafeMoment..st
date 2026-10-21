injecting
whileStoppedAtASafeMoment: aBlock

	"aBlock's value on its heap, read while held still: quiet if that comes within about two seconds,
	else outside a collection (a spinning image is never quiet). Else refused, saying why (#91)."

	40 timesRepeat: [
		(self whileStoppedIf: [ :fresh | fresh isQuiet ifFalse: [ 'running, not waiting in the kernel' ] ] do: aBlock)
			ifNotNil: [ :done | ^ done first ] ].
	5 timesRepeat: [
		(self
			 whileStoppedIf: [ :fresh |
				 | phase |
				 phase := (VMVariables on: fresh) at: 'gcPhaseInProgress'.
				 phase = 0 ifFalse: [ 'collecting garbage (gcPhaseInProgress ' , phase printString , ')' ] ]
			 do: aBlock) ifNotNil: [ :done | ^ done first ] ].
	^ SpurCannotRead new
		  level: #bytes reason: #itWasNeverStoppedAtASafeMoment;
		  detail: 'last try: ' , lastSeen;
		  signal
