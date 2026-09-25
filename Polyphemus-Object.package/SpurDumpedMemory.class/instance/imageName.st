accessing
imageName

	"Where this memory came from: the image the VM was running, when that file is here, so its
	sources are found beside it (#39). Else the dump's own file, or at least a name."

	self imageTheVMRan ifNotNil: [ :path | ^ path ].
	^ (raw space respondsTo: #file)
		  ifTrue: [ raw space file fullName ]
		  ifFalse: [ 'dumped memory' ]
