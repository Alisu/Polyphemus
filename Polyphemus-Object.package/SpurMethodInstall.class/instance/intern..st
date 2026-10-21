interning
intern: aString

	"The image's symbol of that name, made and put in its table when the image has none: looked
	for in its new symbols too, which it keeps apart until it merges them (#106)."

	| found |
	found := self scanTheSymbolTableFor: aString.
	found key ifNotNil: [ ^ found key address ].
	self newSymbols ifNotNil: [ :table |
		(self scan: table for: aString) key ifNotNil: [ :symbol | ^ symbol address ] ].
	^ self internNew: aString at: found value
