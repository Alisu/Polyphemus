building
mapFile: aPath from: aStart to: aStop

	files ifNil: [ files := OrderedCollection new ].
	files add: (ElfMappedFile start: aStart stop: aStop fileOffset: 0 path: aPath)
