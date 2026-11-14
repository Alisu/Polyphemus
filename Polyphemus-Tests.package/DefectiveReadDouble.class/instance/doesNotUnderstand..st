message handling
doesNotUnderstand: aMessage

	| reply |
	reply := replies at: aMessage selector ifAbsent: [ ^ aMessage sendTo: subject ].
	^ reply numArgs = 0
		  ifTrue: [ reply value ]
		  ifFalse: [ reply valueWithArguments: aMessage arguments ]
