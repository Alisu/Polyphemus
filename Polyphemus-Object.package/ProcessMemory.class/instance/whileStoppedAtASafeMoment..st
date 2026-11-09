holding it still
whileStoppedAtASafeMoment: aBlock

	"aBlock's value on a copy of its heap and the reader holding it still, at a safe moment: quiet
	within about two seconds, else outside a collection (a spinning image is never quiet). Else
	refused, saying what the last try saw (#91, #118)."

	| tried |
	40 timesRepeat: [
		tried := self whileStoppedIf: [ :fresh | fresh isQuiet ifFalse: [ 'running, not waiting in the kernel' ] ] do: aBlock.
		tried isArray ifTrue: [ ^ tried first ] ].
	^ self whileStoppedOutsideACollection: aBlock
