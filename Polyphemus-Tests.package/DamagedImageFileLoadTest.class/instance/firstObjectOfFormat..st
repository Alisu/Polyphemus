damaging
firstObjectOfFormat: aFormat

	"The first object of that Spur format the clean reading walks."

	clean do: [ :each | ((each isKindOf: OOPAbstractObject) and: [ each oopFormat = aFormat ]) ifTrue: [ ^ each ] ].
	^ self fail: 'no object of format ' , aFormat printString
