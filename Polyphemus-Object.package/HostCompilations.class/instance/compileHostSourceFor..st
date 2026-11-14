highlighting
compileHostSourceFor: anActivation

	"The method compiled here from its source as the image's compiler would, with its tree:
	{method. tree}; a DoIt from its own source, as a DoIt. A pc maps to source only through it (#4)."

	| home source receiverClass |
	home := [ anActivation homeMethod ] on: PolyphemusError do: [ :e | nil ].
	home ifNil: [ ^ nil ].
	receiverClass := [ anActivation receiver oopClass ] on: PolyphemusError do: [ :e | nil ].
	receiverClass ifNil: [ ^ nil ].
	source := [ home getSourceFromFile ] on: PolyphemusError do: [ :e | nil ].
	(source isNil or: [ source isEmpty ]) ifFalse: [
		^ self compileHostSource: source for: receiverClass ].
	source := [ home doItSource ] on: PolyphemusError do: [ :e | nil ].
	source ifNil: [ ^ nil ].
	^ self compileHostSource: source for: receiverClass doIt: true
