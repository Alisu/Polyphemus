restarting
vm9CouldNotMapItsHeapIn: aLog

	"VM 9 exits when the kernel offers its heap below where the image asks (memoryUnix.c,
	sqAllocateMemory); it happens now and then, and later VMs relocate instead (#31)."

	^ aLog notNil and: [
		  (aLog includesSubstring: 'sqAllocateMemory') and: [
			  aLog includesSubstring: 'I cannot find a good memory address' ] ]
