tests
testAHeldVirtualMachineIsCopiedWithoutCollectingOverAndOver

	"It stands still while it is copied (#85). Read 4 MB at a time, each block an old space
	ByteArray, the copy set off full collections and the target stood still for 3 to 9 s (#87)."

	| pid collections |
	pid := self launchObservableTarget.
	collections := Smalltalk vm parameterAt: 7.
	[ Polyphemus copyProcess: pid ] ensure: [ LibC system: 'kill ' , pid printString ].
	collections := (Smalltalk vm parameterAt: 7) - collections.
	self assert: collections <= 2 description: [ collections printString , ' full collections' ]
