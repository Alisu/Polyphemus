inspection
oopClassChainNames

	"The names of this object's class and its superclasses, as the image has them."

	| class |
	class := self oopClass.
	(class isKindOf: OOPAbstractClass) ifFalse: [ ^ #(  ) ].
	^ ({ class } , class oopSuperclasses) collect: [ :each | each name asString ]
