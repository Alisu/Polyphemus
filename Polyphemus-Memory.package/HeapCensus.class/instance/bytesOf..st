accessing
bytesOf: aClassName

	^ self lines inject: 0 into: [ :sum :each | each name = aClassName ifTrue: [ sum + each bytes ] ifFalse: [ sum ] ]
