moments
whereItReadsWholeDo: aBlock

	"aBlock's value on a copy of its heap and the reader holding it still, stopped at a moment no
	collection moves objects and its classes and special objects read whole (#113). Else refused."

	^ self
		  after: 0
		  lookUntil: [ self stoppedIf: [ :fresh | self class whyObjectsMoveIn: (VMVariables on: fresh) ] do: aBlock ]
		  once: false
