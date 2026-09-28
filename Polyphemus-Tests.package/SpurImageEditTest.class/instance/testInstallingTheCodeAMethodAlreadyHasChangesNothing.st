tests
testInstallingTheCodeAMethodAlreadyHasChangesNothing

	"Rung 1 of #25 aimed at itself: a method recompiled here and written back over itself
	gives the same file, byte for byte. The arithmetic of where code sits proves itself."

	| reading edit activation host |
	reading := Polyphemus readImageFile: PharoImageAccessor pathToTargetImage.
	edit := SpurEdit on: (SpurWritableImageFile on: PharoImageAccessor pathToTargetImage) reading: reading.
	activation := (reading activationsOfProcess: reading reifiedActiveProcess) detect: [ :each |
		                  [ (reading hostMethodFor: each) notNil ] on: Error do: [ :e | false ] ].
	host := reading hostMethodFor: activation.

	edit replaceCodeOfMethodShown: activation homeMethod from: host to: host.
	edit memory writeTo: written.

	self
		assert: (written binaryReadStreamDo: [ :each | each upToEnd ])
		equals: (PharoImageAccessor pathToTargetImage asFileReference binaryReadStreamDo: [ :each |
				 each upToEnd ])
