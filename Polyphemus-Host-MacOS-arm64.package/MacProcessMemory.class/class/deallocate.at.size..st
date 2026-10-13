library
deallocate: aTask at: anAddress size: aSize

	^ self ffiCall: #( int mach_vm_deallocate ( uint32 aTask , uint64 anAddress , uint64 aSize ) )
