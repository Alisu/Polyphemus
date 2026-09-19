accessing
mapping

	"The VM library's first mapping: file offset 0, where its ELF header is."

	^ mapping ifNil: [
		  mapping := memory mappedFiles
			             detect: [ :each |
				             (each path endsWith: '/libPharoVMCore.so') and: [ each fileOffset = 0 ] ]
			             ifNone: [ ^ self refuse: #theVMLibraryIsNotMappedInIt ] ]
