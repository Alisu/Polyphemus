testing
isASelector: aString

	"A unary, binary or keyword selector, spelled as it is with nothing around it: a keyword one is
	names each ended by a colon, none of them empty."

	| parts |
	(self isAName: aString) ifTrue: [ ^ true ].
	(aString notEmpty and: [ aString allSatisfy: [ :each | '-+*/\<>=~@%&?,|' includes: each ] ]) ifTrue: [ ^ true ].
	(aString notEmpty and: [ aString last = $: ]) ifFalse: [ ^ false ].
	parts := aString substrings: ':'.
	^ parts size = (aString occurrencesOf: $:) and: [ parts allSatisfy: [ :each | self isAName: each ] ]
