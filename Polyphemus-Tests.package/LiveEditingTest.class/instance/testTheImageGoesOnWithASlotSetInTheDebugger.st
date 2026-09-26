tests
testTheImageGoesOnWithASlotSetInTheDebugger

	"A slot of an object the debugger shows, set while the image is held (#20): let go, the
	image goes on with it -- here out of the loop that kept it running away. The flag is
	reached as in an inspector, through the block timesRepeat: runs, which copied it."

	| pid session context flag |
	pid := self launchTargetRunning: (PolyphemusAgent watcherSourceWatching: self spikeDirectory afterwards: '') , '
[ [ :flag |
	[ flag first = 1 ] whileTrue: [ 1000 timesRepeat: [ flag size. 3 sqrt ] ].
	(dir / ''stopped'') ensureCreateFile ] value: (Array with: 1) ] forkAt: 40.
(dir / ''started'') ensureCreateFile.
(Delay forSeconds: 120) wait.
Smalltalk exitSuccess'.
	[
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	context := session interruptedContext findContextSuchThat: [ :each |
		           each selector = #timesRepeat: ].
	flag := (context tempNamed: 'aBlock') reifiedSlotAt: 5.
	self assert: (flag reifiedSlotAt: 1) asInteger equals: 1.
	session store: 2 inSlot: 1 ofObjectShown: flag.
	session resume.
	self
		assert: (self waitFor: [ (self spikeDirectory / 'stopped') exists ])
		description: 'the image never saw the slot set' ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
