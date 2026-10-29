highlighting
compileHostSourceFor: anActivation

	"The method compiled here from its source as the image's compiler would, with its tree:
	{method. tree}; a DoIt from its own source, as a DoIt. A pc maps to source only through it (#4)."

	| home source |
	home := [ anActivation homeMethod ] on: Error do: [ :e | nil ].
	home ifNil: [ ^ nil ].
	source := [ home getSourceFromFile ] on: Error do: [ :e | nil ].
	(source isNil or: [ source isEmpty ]) ifFalse: [
		^ self compileHostSource: source for: anActivation receiver oopClass ].
	source := [ home doItSource ] on: Error do: [ :e | nil ].
	source ifNil: [ ^ nil ].
	^ self compileHostSource: source for: anActivation receiver oopClass doIt: true
