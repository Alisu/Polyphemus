printing
objectNameIfAny
	| className |
	memory nilObject = address ifTrue: [ ^ #nilObject ].
	memory trueObject = address ifTrue: [ ^ #trueObject ].
	memory falseObject = address ifTrue: [ ^ #falseObject ].
	memory specialObjectsOop = address ifTrue: [ ^ #specialObjectArray ].

	className := self oopClass oopName.
	^ 'Instance of ' , className