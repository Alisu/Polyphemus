tests
testTheLoopOfAScriptShowsItsCode

	"A process a script forked loops in a block of the script's own code, a DoIt: its frame shows
	that block's code, or at least its bytecodes, not the whole script's (#100)."

	| pid memory frame code |
	pid := self launchTargetRunning: '| dir |
dir := ' , self spikeDirectory fullName printString , ' asFileReference.
[ [ (Delay forMilliseconds: 50) wait ] repeat ] forkNamed: ''scripted''.
(Delay forSeconds: 1) wait.
Smalltalk saveAs: (dir / ''scripted'') fullName.
(dir / ''started'') ensureCreateFile.
(Delay forSeconds: ' , self targetLifetime printString , ') wait.
Smalltalk exitSuccess'.
	LibC system: 'kill -9 ' , pid printString.
	memory := Polyphemus readImageFile: (self spikeDirectory / 'scripted.image') fullName.
	frame := (memory contextsOfProcess: (Polyphemus processNamed: 'scripted' in: memory)) detect: [ :each |
		         each selector = #DoIt ].
	code := frame sourceCode.
	self deny: (code includesSubstring: 'unreadable') description: code.
	self assert: (code includesSubstring: 'forMilliseconds:') description: code.
	self deny: (code includesSubstring: 'saveAs:') description: code
