naming
analysedNodeOf: anActivation

	"The method parsed and analysed (not compiled) against its class in the image read, with
	semantic warnings off to keep our Undeclared clean. Needs the real source. Cached."

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
