tests
testWhatItSaysIsNotWrittenThroughALink

	"#179: the helper writes its state under a temporary name, then renames it. A link planted
	under that name is taken away, and what it pointed at holds what it held."

	| elsewhere |
	elsewhere := self aFileElsewhere.
	[
	LibC system: 'ln -s ''' , elsewhere fullName , ''' ''' , (directory / 'said.state.tmp') fullName , ''''.
	self helperFedBy: 'sleep 2' bound: 30 saying: 'said.state'.
	self assert: (self within: 5 seconds comesTrue: [ (self said: 'said.state') = 'stopped' ]).
	self assert: elsewhere contents equals: 'mine'.
	self assert: (self within: 10 seconds comesTrue: [ (self said: 'said.state') = 'resumed' ]) ] ensure: [
		elsewhere ensureDelete ]
