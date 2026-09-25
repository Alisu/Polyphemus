reading
forgetAllButClasses

	"The memory under this reading changed, its classes did not: every wrapper but theirs is
	dropped, since a young address can hold another object now, and so is what was worked out."

	self forgetWhatWasRead.
	objectsArray := objectsArray collect: [ :each |
		                (each isKindOf: OOPAbstractClass) ifTrue: [ each ] ifFalse: [ nil ] ].
	self createCompressedVersion
