accessing
objects
	"recreate the object collection only when needed"
	self complete.
	lastObjectAccess < objects size ifTrue: [ self createCompressedVersion ].
	lastObjectAccess := objects size.
	^ objects
