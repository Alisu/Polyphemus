tests
testAMarkThatIsALinkIsNotWrittenThrough

	"#179: a link planted under the mark's name is taken away and a mark of the helper's own made:
	the stop holds, and what the link pointed at holds what it held."

	| elsewhere stop |
	elsewhere := self aFileElsewhere.
	[
	LibC system: 'ln -s ''' , elsewhere fullName , ''' ''' , (directory / (target printString , '.mark')) fullName , ''''.
	stop := StopHelper on: target in: directory.
	self assert: stop start.
	self assert: stop end.
	self assert: elsewhere contents equals: 'mine' ] ensure: [ elsewhere ensureDelete ]
