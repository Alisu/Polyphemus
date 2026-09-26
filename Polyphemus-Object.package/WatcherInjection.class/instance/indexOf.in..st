private
indexOf: aName in: aClassName

	"Where that instance variable is, counted from zero, as that image lays the class out: read
	from its class, not assumed, so another version's order is followed."

	| index |
	index := ((reading oopClassNamed: aClassName) allInstVarNames collect: [ :each | each asString ])
		         indexOf: aName.
	index = 0 ifTrue: [ ^ self error: aClassName , ' has no ' , aName , ' in this image' ].
	^ index - 1
