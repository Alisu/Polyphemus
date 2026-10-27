highlighting
compileHostSourceFor: anActivation

	"The method compiled here from its source as the image's compiler would, with its tree:
	{method. tree}. A pc maps to source only through the tree that made the method (#4)."

	| source |
	source := [ anActivation homeMethod getSourceFromFile ] on: Error do: [ :e | nil ].
	(source isNil or: [ source isEmpty ]) ifTrue: [ ^ nil ].
	^ self compileHostSource: source for: anActivation receiver oopClass
