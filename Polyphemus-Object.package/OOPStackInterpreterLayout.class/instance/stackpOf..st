reading
stackpOf: aFrame

	^ [ (self isActiveFrame: aFrame framePointer)
		  ifTrue: [
			  memory interpreter
				  stackPointerIndexForFrame: aFrame framePointer
				  WithSP: memory interpreter stackPointer ]
		  ifFalse: [ memory interpreter stackPointerIndexForFrame: aFrame framePointer ] ]
		  on: Error
		  do: [ :e | nil ]
