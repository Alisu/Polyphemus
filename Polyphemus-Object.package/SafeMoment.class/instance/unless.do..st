moments
unless: aWhyBlock do: aBlock

	"aBlock's value, the reader stopped at a moment aWhyBlock, given the VM's variables, answers nil
	for: looked for 20 ms apart, once when the reader's caller holds it stopped. Else refused (#186)."

	| once |
	once := reader isStoppedHere.
	^ self
		  after: 0
		  lookUntil: [
			  | why answer |
			  answer := reader whileStopped: [
				            why := aWhyBlock value: (VMVariables on: reader).
				            why ifNil: [ { aBlock value } ] ifNotNil: [ nil ] ].
			  answer ifNil: [
				  once ifFalse: [ (Delay forMilliseconds: 20) wait ].
				  why ] ]
		  once: once
