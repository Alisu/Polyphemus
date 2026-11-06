tests
testACallWaitingForAChildSaysSo

	"#159: wait4 has no descriptor: what it waits on is a child process."

	| pid |
	pid := self launchTargetRunning: '| dir | dir := ' , self spikeDirectory fullName printString , ' asFileReference.
(dir / ''started'') ensureCreateFile.
LibC system: ''sleep 600''.
Smalltalk exitSuccess'.
	[
	self assert: (self waitFor: [ (Polyphemus whereIsStuck: pid) mainThread systemCallName = 'wait4' ]).
	self assert: (Polyphemus whereIsStuck: pid) mainThread waitsOn equals: 'a child process' ] ensure: [
		LibC system: 'pkill -P ' , pid printString , '; kill ' , pid printString ]
