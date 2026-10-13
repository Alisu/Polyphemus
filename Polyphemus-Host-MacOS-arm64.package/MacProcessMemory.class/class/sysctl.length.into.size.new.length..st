library
sysctl: aName length: aLength into: aBuffer size: aSize new: aNewValue length: aNewLength

	^ self ffiCall: #( int sysctl ( void * aName , uint32 aLength , void * aBuffer , void * aSize , void * aNewValue , uint64 aNewLength ) )
