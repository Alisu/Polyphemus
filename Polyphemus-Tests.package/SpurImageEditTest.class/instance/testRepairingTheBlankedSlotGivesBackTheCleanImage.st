tests
testRepairingTheBlankedSlotGivesBackTheCleanImage

	"The blanked fixture is the clean image with one slot zeroed. Writing the clean image's
	word back into that slot gives the clean file again, byte for byte."

	| clean damaged slot word |
	clean := SpurImageEdit on: PharoImageAccessor pathToPharo10.
	damaged := SpurImageEdit on: BlankedContextImageResource corruptedImagePath.
	slot := self suspendedContextSlotOf: clean.
	word := clean raw scanner slotOf: slot key at: slot value.

	self assert: (damaged raw scanner slotOf: slot key at: slot value) equals: 0.
	damaged storePointer: slot value ofObject: slot key value: word.
	damaged writeTo: written.

	self
		assert: (written binaryReadStreamDo: [ :each | each upToEnd ])
		equals: (PharoImageAccessor pathToPharo10 asFileReference binaryReadStreamDo: [ :each | each upToEnd ])
