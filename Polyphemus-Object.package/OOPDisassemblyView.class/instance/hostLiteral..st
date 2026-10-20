private
hostLiteral: anOop

	"A literal of the other image as ours: a symbol or string as itself, a variable as one named
	the same, a block as its own view; else its printString, which is all a disassembly shows."

	| name |
	(anOop isKindOf: OOPCompiledBlock) ifTrue: [ ^ self class on: anOop ].
	(anOop isKindOf: OOPString) ifTrue: [
		^ (anOop oopClassName endsWith: 'Symbol')
			  ifTrue: [ anOop asSymbol ]
			  ifFalse: [ anOop asString ] ].
	((anOop isKindOf: OOPImmediate) and: [ anOop oopClassName = 'SmallInteger' ]) ifTrue: [ ^ anOop asInteger ].
	(anOop isKindOf: OOPAbstractObject) ifFalse: [ ^ anOop ].
	name := [ (anOop oopSlotNamed: #key) ifNil: [ anOop oopSlotNamed: #name ] ] on: Error do: [ :e | nil ].
	(name isKindOf: OOPString) ifTrue: [ ^ GlobalVariable key: name asSymbol value: nil ].
	^ [ anOop printString ] on: Error do: [ :e | anOop oopClassName ]
