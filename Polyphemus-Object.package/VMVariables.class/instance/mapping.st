accessing
mapping

	"The VM library's first mapping, where its header is: of the regions named as it at offset 0
	(macOS names a page of zeros before its code so too), the one starting with a header."

	^ mapping ifNil: [
		  | candidates |
		  candidates := memory mappedFiles select: [ :each |
			                (VMVariables isTheVMLibrary: each path) and: [ each fileOffset = 0 ] ].
		  candidates ifEmpty: [ ^ self refuse: #theVMLibraryIsNotMappedInIt ].
		  mapping := candidates
			             detect: [ :each | self startsWithAHeader: each ]
			             ifNone: [ candidates first ] ]
