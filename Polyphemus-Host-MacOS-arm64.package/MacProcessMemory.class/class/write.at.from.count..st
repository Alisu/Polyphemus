library
write: aTask at: anAddress from: aBuffer count: aCount

	^ self ffiCall: #( int mach_vm_write ( uint32 aTask , uint64 anAddress , void * aBuffer , uint32 aCount ) )
