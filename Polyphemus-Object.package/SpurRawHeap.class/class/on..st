instance creation
on: aDump

	"A reader on aDump's heap: the mapping holding where old space is stated to start (an
	image header's oldBaseAddress, the VM's nilObj) and every mapping contiguous after it.
	The largest mapping when nothing is stated: not the heap once a host has grown (#13)."

	| variables stated first limit following |
	aDump loadableSegments ifEmpty: [ ^ self on: aDump from: 0 to: 0 ].
	variables := VMVariables on: aDump.
	stated := self statedHeapStartIn: aDump variables: variables.
	first := (stated ifNotNil: [
		          aDump loadableSegments
			          detect: [ :each | each holdsAddress: stated ]
			          ifNone: [ nil ] ]) ifNil: [
		         aDump loadableSegments detectMax: [ :each | each sizeInFile ] ].
	limit := first address + first sizeInFile.
	[
	following := aDump loadableSegments
		             detect: [ :each |
			             each address = limit and: [ each sizeInFile > 0 ] ]
		             ifNone: [ nil ].
	following notNil ] whileTrue: [ limit := limit + following sizeInFile ].
	^ (self on: aDump from: first address to: limit)
		  setVMVariables: variables;
		  findYoungMapping;
		  yourself
