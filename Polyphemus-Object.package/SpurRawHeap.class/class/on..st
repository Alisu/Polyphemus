instance creation
on: aDump

	"A reader on aDump's heap: the mapping holding where old space is stated to start (an
	image header's oldBaseAddress, the VM's nilObj) and every mapping after it, touching or across
	a segment's bridge. The largest mapping when nothing is stated: not the heap once a host has grown (#13)."

	| variables stated first end |
	aDump loadableSegments ifEmpty: [ ^ self on: aDump from: 0 to: 0 ].
	variables := VMVariables on: aDump.
	stated := self statedHeapStartIn: aDump variables: variables.
	first := (stated ifNotNil: [
		          aDump loadableSegments
			          detect: [ :each | each holdsAddress: stated ]
			          ifNone: [ nil ] ]) ifNil: [
		         aDump loadableSegments detectMax: [ :each | each sizeInFile ] ].
	end := [ variables at: 'endOfMemory' ] on: Error do: [ :error | nil ].
	(end isInteger and: [ end > first address ]) ifFalse: [ end := nil ].
	^ (self on: aDump from: first address to: (self limitOf: first in: aDump endingBy: end))
		  setVMVariables: variables;
		  findYoungMapping;
		  yourself
