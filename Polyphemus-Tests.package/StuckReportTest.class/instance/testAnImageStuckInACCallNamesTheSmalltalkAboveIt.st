tests
testAnImageStuckInACCallNamesTheSmalltalkAboveIt

	"#18: under a C call, the report names the Smalltalk process and method that called into C,
	and the native debugger's command that goes on from there."

	| pid report |
	pid := self launchTargetRunning: '| dir | dir := ' , self spikeDirectory fullName printString , ' asFileReference.
[ LibC system: ''sleep 600'' ] forkNamed: ''stuck''.
(dir / ''started'') ensureCreateFile.
(Delay forSeconds: 600) wait'.
	[
	self assert: (self waitFor: [ (Polyphemus whereIsStuck: pid) mainThread systemCallName = 'wait4' ]).
	report := Polyphemus whereIsStuck: pid reading: (Polyphemus readProcess: pid).

	self
		assert: ((report smalltalkAboveC ifNil: [ '' ]) includesSubstring: 'process ''stuck''')
		description: [ report printString ].
	self assert: (report smalltalkAboveC includesSubstring: 'system:') description: [ report printString ].
	self assert: (report printString includesSubstring: report smalltalkAboveC).
	self assert: (report printString includesSubstring: 'gdb -p ' , pid printString) ] ensure: [
		LibC system: 'pkill -P ' , pid printString , '; kill ' , pid printString ]
