accessing
imageTheVMRan

	"The path the VM kept in its imageName, when it is a file on this machine; nil otherwise."

	| path |
	path := [ raw vmVariables stringAt: 'imageName' ] on: Error do: [ :e | nil ].
	(path isEmptyOrNil or: [ path asFileReference isFile not ]) ifTrue: [ ^ nil ].
	^ path asFileReference fullName
