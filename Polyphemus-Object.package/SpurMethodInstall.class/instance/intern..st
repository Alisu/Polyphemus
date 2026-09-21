interning
intern: aString

	"The image's symbol of that name, made and put in its table when the image has none."

	| found |
	found := self scanTheSymbolTableFor: aString.
	found key ifNotNil: [ ^ found key address ].
	^ self internNew: aString at: found value
