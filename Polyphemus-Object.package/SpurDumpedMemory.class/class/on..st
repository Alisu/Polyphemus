instance creation
on: aDump

	^ self new setRaw: (SpurRawHeap on: aDump); yourself
