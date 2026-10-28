debugger protocol
nearestClassHere

	"The nearest class up my superclass chain that this image has by name, on my side, Object's
	when none: for Pharo's tools, which ask a class what only a class of this image answers (#120)."

	| class |
	class := self.
	1000 timesRepeat: [
		(class isKindOf: OOPAbstractClass) ifFalse: [ ^ self isClassSideOop ifTrue: [ Object class ] ifFalse: [ Object ] ].
		(self class environment classNamed: class oopInstanceSide name) ifNotNil: [ :found |
			^ self isClassSideOop ifTrue: [ found class ] ifFalse: [ found ] ].
		class := class oopSuperclass ].
	^ Object
