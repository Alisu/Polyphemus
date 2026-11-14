finding
atOrBefore: anAddress

	"The object kept at anAddress, or the last one below it, across ranges."

	| range from |
	range := self rangeHolding: anAddress.
	range ifNil: [ ^ NotInTheReading signal: 'no object at or before ' , anAddress printStringHex ].
	from := anAddress - (starts at: range) >> 3 + 1.
	range to: 1 by: -1 do: [ :each |
		| array |
		array := slots at: each.
		(from min: array size) to: 1 by: -1 do: [ :index |
			(array at: index) ifNotNil: [ :found | ^ found ] ].
		each > 1 ifTrue: [ from := (slots at: each - 1) size ] ].
	^ NotInTheReading signal: 'no object at or before ' , anAddress printStringHex
