tests
testALockThatIsALinkIsNotFollowed

	"#179: the lock's name can be foretold, and the directory is open to all. A link planted under
	it is not opened: no stop, and what it points at keeps its mode and what it holds."

	| elsewhere stop |
	elsewhere := self aFileElsewhere.
	[
	LibC system: 'ln -s ''' , elsewhere fullName , ''' ''' , (directory / (target printString , '.lock')) fullName , ''''.
	stop := StopHelper on: target in: directory.
	self deny: stop start.
	self deny: self isStopped.
	self assert: (self modeOf: elsewhere) equals: '-rw-------'.
	self assert: elsewhere contents equals: 'mine' ] ensure: [ elsewhere ensureDelete ]
