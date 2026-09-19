naming
analysedNodeOf: anActivation

	"The activation's method parsed and analysed (not compiled) against its class in the
	image being read. Semantic warnings are off so unknown names stay out of our
	Undeclared. Needs the real source: decompiled source invents names. Cached per method
	and class."

	| home receiverClass |
	home := [ anActivation homeMethod ] on: Error do: [ :e | nil ].
	receiverClass := [ anActivation receiver oopClass ] on: Error do: [ :e | nil ].
	(home isNil or: [ receiverClass isNil ]) ifTrue: [ ^ nil ].

	^ (self
		   rememberedAt: 'analysed.' , home address printString , '.'
			   , receiverClass address printString
		   ifAbsentPut: [
			   (self analyseMethodOf: home against: receiverClass) ifNil: [ false ] ])
		  ifNotNil: [ :cached | cached == false ifTrue: [ nil ] ifFalse: [ cached ] ]
