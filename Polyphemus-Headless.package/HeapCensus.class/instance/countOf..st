accessing
countOf: aClassName

	^ self lines inject: 0 into: [ :sum :each | each name = aClassName ifTrue: [ sum + each count ] ifFalse: [ sum ] ]
