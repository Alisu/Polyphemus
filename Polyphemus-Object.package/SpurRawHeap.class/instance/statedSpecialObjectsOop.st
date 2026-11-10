finding a heap
statedSpecialObjectsOop

	"Where the special objects array is stated to be -- an image header says, or a VM its variable
	(#129) -- believed if it is in this mapping and has the array's shape. The search by shape alone
	can pick another array of that shape: on candle it did (#43)."

	| stated |
	stated := space specialObjectsOop ifNil: [
		          [ self vmVariables at: 'specialObjectsOop' ] on: Error do: [ :error | ^ nil ] ].
	^ ((stated isInteger and: [ stated between: mappingStart and: mappingLimit - 1 ]) and: [
		   self scanner looksLikeTheSpecialObjectsArrayAt: stated from: heapStart ])
		  ifTrue: [ stated ]
		  ifFalse: [ nil ]
