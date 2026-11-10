holding it still
whileStoppedAtASafeMoment: aBlock

	"aBlock's value on a copy of its heap and the reader holding it still, at a safe moment: quiet
	within about two seconds, else outside a collection and machine code, else outside a collection
	only, saying so (a spinning image may never leave machine code, #167). Else refused (#91)."

	| tried |
	40 timesRepeat: [
		tried := self whileStoppedIf: [ :fresh | fresh isQuiet ifFalse: [ 'running, not waiting in the kernel' ] ] do: aBlock.
		tried isArray ifTrue: [ ^ tried first ] ].
	5 timesRepeat: [
		tried := self
			         whileStoppedIf: [ :fresh | self class whyNotToAllocateIn: (VMVariables on: fresh) ]
			         do: aBlock.
		tried isArray ifTrue: [ ^ tried first ] ].
	WrittenInMachineCode signal: 'never stopped outside machine code: written while it ran it (#167)'.
	^ self whileStoppedOutsideACollection: aBlock
