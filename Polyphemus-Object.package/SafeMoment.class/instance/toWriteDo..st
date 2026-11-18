moments
toWriteDo: aBlock

	"aBlock's value on a copy of its heap and the reader holding it still: quiet and outside a
	collection within about two seconds, else as whyNotToAllocateIn: allows (#167). Else refused."

	| tried |
	40 timesRepeat: [
		tried := self
			         stoppedIf: [ :fresh |
				         fresh isQuiet
					         ifTrue: [ fresh whyCollecting ]
					         ifFalse: [ 'running, not waiting in the kernel' ] ]
			         do: aBlock.
		tried isArray ifTrue: [ ^ tried first ] ].
	^ self
		  after: 40
		  lookUntil: [ self stoppedIf: [ :fresh | self class whyNotToAllocateIn: (VMVariables on: fresh) ] do: aBlock ]
		  once: false
