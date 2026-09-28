accessing
imageTheVMRan

	"The path the VM kept in its imageName (_imageName from VM 12), when it is a file on this
	machine; nil otherwise."

	| path |
	path := #( 'imageName' '_imageName' ) inject: nil into: [ :found :each |
		        found ifNil: [ [ raw vmVariables stringAt: each ] on: Error do: [ :e | nil ] ] ].
	(path isEmptyOrNil or: [ path asFileReference isFile not ]) ifTrue: [ ^ nil ].
	^ path asFileReference fullName
