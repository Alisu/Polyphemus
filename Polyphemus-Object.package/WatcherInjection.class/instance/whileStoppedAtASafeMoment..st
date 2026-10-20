injecting
whileStoppedAtASafeMoment: aBlock

	"aBlock's value on its heap, read while held still: quiet if that comes within about two seconds,
	else outside a collection (a spinning image is never quiet). Else refused (#91)."

	40 timesRepeat: [ (self whileStoppedIf: [ :fresh | fresh isQuiet ] do: aBlock) ifNotNil: [ :done | ^ done first ] ].
	5 timesRepeat: [
		(self whileStoppedIf: [ :fresh | ((VMVariables on: fresh) at: 'gcPhaseInProgress') = 0 ] do: aBlock)
			ifNotNil: [ :done | ^ done first ] ].
	^ (SpurCannotRead new level: #bytes reason: #itWasNeverStoppedAtASafeMoment) signal
