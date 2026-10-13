library
fileOf: aPid at: anAddress into: aBuffer size: aSize

	^ self ffiCall: #( int proc_regionfilename ( int aPid , uint64 anAddress , void * aBuffer , uint32 aSize ) )
