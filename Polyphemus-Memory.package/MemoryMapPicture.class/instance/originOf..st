accessing
originOf: anIndex

	"Where that section's top left pixel is: under the ones before it, each with a title line."

	| y |
	y := 10.
	1 to: anIndex do: [ :each |
		(sections at: each) key ifNotNil: [ y := y + 20 ].
		each < anIndex ifTrue: [ y := y + (self geometryOf: each) height + 10 ] ].
	^ 150 @ y
