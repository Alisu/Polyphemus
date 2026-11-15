private
hostLiteral: anOop

	"A literal of the other image as ours: a symbol or string as itself, a variable as one named
	the same, a block as its own view; else its printString, which is all a disassembly shows,
	as for one that does not read."

	| name |
	(anOop isKindOf: OOPCompiledBlock) ifTrue: [ ^ self class on: anOop ].
	(anOop isKindOf: OOPString) ifTrue: [
		^ (anOop oopClassName endsWith: 'Symbol')
			  ifTrue: [ anOop asSymbol ]
			  ifFalse: [ anOop asString ] ].
	((anOop isKindOf: OOPImmediate) and: [ anOop isIntegerOop ]) ifTrue: [ ^ anOop asInteger ].
	anOop isUnreadableSlot ifTrue: [ ^ anOop printString ].
	(anOop isKindOf: OOPAbstractObject) ifFalse: [ ^ anOop ].
	name := (anOop oopSlotNamed: #key) ifNil: [ anOop oopSlotNamed: #name ].
	(name isKindOf: OOPString) ifTrue: [ ^ GlobalVariable key: name asSymbol value: nil ].
	^ anOop printString
