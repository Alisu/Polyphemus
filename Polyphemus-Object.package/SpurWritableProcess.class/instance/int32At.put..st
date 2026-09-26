words
int32At: anAddress put: anInteger

	| value |
	value := anInteger < 0
		         ifTrue: [ anInteger + 16r100000000 ]
		         ifFalse: [ anInteger ].
	self
		storeBytes: ((0 to: 3) collect: [ :each | (value bitShift: each * -8) bitAnd: 255 ])
				asByteArray
		at: anAddress
