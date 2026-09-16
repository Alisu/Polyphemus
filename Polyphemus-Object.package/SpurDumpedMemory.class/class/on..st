instance creation
on: aDump

	"The heap of a dump lives in the mapping the VM asked the operating system for, which
	is the largest one: a VM takes its heap in a single mapping."

	| region |
	region := aDump loadableSegments detectMax: [ :each | each sizeInFile ].
	^ self
		  on: aDump
		  from: region address
		  to: region address + region sizeInFile
