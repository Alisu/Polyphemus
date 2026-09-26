enumerating
select: aBlock

	^ Array streamContents: [ :stream |
		  self do: [ :each | (aBlock value: each) ifTrue: [ stream nextPut: each ] ] ]
