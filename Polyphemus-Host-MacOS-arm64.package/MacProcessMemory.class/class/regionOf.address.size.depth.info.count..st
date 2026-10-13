library
regionOf: aTask address: anAddressBuffer size: aSizeBuffer depth: aDepthBuffer info: anInfoBuffer count: aCountBuffer

	^ self ffiCall: #( int mach_vm_region_recurse ( uint32 aTask , void * anAddressBuffer , void * aSizeBuffer , void * aDepthBuffer , void * anInfoBuffer , void * aCountBuffer ) )
