tests
testTheHeapOfAHeldVirtualMachineIsCopiedWhole

	"What readProcess: copies while it holds the VM: its old space mapping, segment by segment,
	to the end. Where the copy stops short, which regions lie around that address."

	| pid reader raw start limit |
	pid := self launchIdleTarget.
	[
	reader := WindowsProcessMemory on: pid.
	reader whileStopped: [
		raw := (SpurDumpedMemory on: reader) raw.
		start := raw mappingStart.
		limit := raw mappingLimit.
		raw bytes ].
	self
		assert: raw mappingLimit = limit
		description: [
			String streamContents: [ :s |
				s nextPutAll: 'mapping ' , start printStringHex , ' to ' , limit printStringHex , ', copied to '
					, raw mappingLimit printStringHex , '; regions around: '.
				(reader segments select: [ :each |
					 each address + each sizeInMemory > (raw mappingLimit - 16r400000) and: [
						 each address < (raw mappingLimit + 16r400000) ] ]) do: [ :each |
					s nextPutAll: each address printStringHex , '+' , each sizeInMemory printStringHex , ' ' ] ] ] ] ensure: [
		reader ifNotNil: [ reader close ].
		LibC system: 'taskkill /F /PID ' , pid printString ]
