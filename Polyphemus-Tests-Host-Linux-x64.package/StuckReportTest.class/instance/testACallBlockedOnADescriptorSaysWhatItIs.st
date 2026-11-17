tests
testACallBlockedOnADescriptorSaysWhatItIs

	"#159: not only read and its first argument: what that descriptor is, here a pipe nobody writes,
	read by the VM's own thread."

	| fifo pid report |
	fifo := self spikeDirectory / 'stuck.fifo'.
	pid := self launchTargetRunning: '| dir | dir := ' , self spikeDirectory fullName printString , ' asFileReference.
LibC system: ''mkfifo ' , fifo fullName , '; sleep 60 > ' , fifo fullName , ' &''.
(dir / ''started'') ensureCreateFile.
' , fifo fullName printString , ' asFileReference binaryReadStream next.
Smalltalk exitSuccess'.
	[
	self assert: (self waitFor: [ (Polyphemus whereIsStuck: pid) mainThread systemCallName = 'read' ]).
	report := Polyphemus whereIsStuck: pid.
	self assert: (report mainThread waitsOn includesSubstring: fifo basename).
	self assert: (report printString includesSubstring: fifo basename) ] ensure: [
		LibC system: 'kill ' , pid printString ]
