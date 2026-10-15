library
query: aHandle at: anAddress into: aBuffer size: aSize

	^ self ffiCall: #( uint64 VirtualQueryEx ( uint64 aHandle , uint64 anAddress , void * aBuffer , uint64 aSize ) )
