accessing
heldByteCount

	"How many bytes of the mapping this heap holds a copy of: no more than its memory holds."

	^ self pieces inject: 0 into: [ :sum :each | sum + each size ]
