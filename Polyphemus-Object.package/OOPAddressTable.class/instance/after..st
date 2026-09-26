finding
after: anAddress

	"The first object kept at an address above anAddress, across ranges; nil if none."

	| range from |
	range := self rangeHolding: anAddress.
	range ifNil: [ ^ nil ].
	from := anAddress - (starts at: range) >> 3 + 2.
	range to: slots size do: [ :each |
		| array |
		array := slots at: each.
		from to: array size do: [ :index | (array at: index) ifNotNil: [ :found | ^ found ] ].
		from := 1 ].
	^ nil
