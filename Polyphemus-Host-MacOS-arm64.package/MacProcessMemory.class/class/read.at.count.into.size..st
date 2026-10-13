library
read: aTask at: anAddress count: aCount into: aBuffer size: aSizeBuffer

	^ self ffiCall: #( int mach_vm_read_overwrite ( uint32 aTask , uint64 anAddress , uint64 aCount , void * aBuffer , void * aSizeBuffer ) )
