building the memory
stretchesDo: aBlock

	"The pieces of the mapping, each that touches the one before joined to it, with the pieces
	it is made of: a heap in one stretch is read as one ByteArray, the fastest walk."

	| parts |
	parts := OrderedCollection new.
	self piecesDo: [ :from :upTo |
		(parts notEmpty and: [ parts last value ~= from ]) ifTrue: [
			aBlock value: parts first key value: parts last value value: parts.
			parts := OrderedCollection new ].
		parts add: from -> upTo ].
	parts ifNotEmpty: [ aBlock value: parts first key value: parts last value value: parts ]
