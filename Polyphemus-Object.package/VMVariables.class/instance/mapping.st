accessing
mapping

	"The VM library's first mapping: file offset 0, where its header is."

	^ mapping ifNil: [
		  mapping := memory mappedFiles
			             detect: [ :each | (VMVariables isTheVMLibrary: each path) and: [ each fileOffset = 0 ] ]
			             ifNone: [ ^ self refuse: #theVMLibraryIsNotMappedInIt ] ]
