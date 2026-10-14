tests
testAZipUnpacksUnderOneNameAndLeavesNothingElse

	"Where no shell fetches (Windows), the image's zip is unpacked here: its three files renamed
	after the image, and nothing else left in resources."

	| directory resources zip |
	directory := PolyphemusEdition current scratch / 'polyphemus-unpack-test'.
	directory ensureDeleteAll.
	resources := (directory / 'resources') ensureCreateDirectory.
	zip := directory / 'Fake.zip'.
	zip binaryWriteStreamDo: [ :stream |
		ZipArchive new
			addString: 'image' as: 'Fake.image';
			addString: 'changes' as: 'Fake.changes';
			addString: 'sources' as: 'Fake-64bit.sources';
			writeTo: stream ].

	PharoImageAccessor unpack: zip named: 'cleanFake' into: resources.

	self
		assert: (resources children collect: [ :each | each basename ]) asSortedCollection asArray
		equals: #( 'cleanFake.changes' 'cleanFake.image' 'cleanFake.sources' ).
	self assert: (resources / 'cleanFake.image') contents equals: 'image'.
	self assert: (resources / 'cleanFake.sources') contents equals: 'sources'
