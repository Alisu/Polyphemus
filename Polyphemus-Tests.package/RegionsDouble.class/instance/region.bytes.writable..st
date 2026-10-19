building
region: anAddress bytes: aByteArray writable: aBoolean

	regions ifNil: [ regions := OrderedCollection new. writable := Set new ].
	regions add: (ByteArrayAddressSpace on: aByteArray at: anAddress).
	aBoolean ifTrue: [ writable add: anAddress ]
