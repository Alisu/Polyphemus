tests
testARegionMadeAfterAStopIsReadAtTheNext

	"The map read at one stop is not the map of the next: an image that grew its heap meanwhile
	is read with its new region (#102)."

	| pid reader total before after |
	pid := self launchTargetRunning: '| dir kept |
dir := ' , self spikeDirectory fullName printString , ' asFileReference.
(dir / ''started'') ensureCreateFile.
[ (dir / ''grow'') exists ] whileFalse: [ (Delay forMilliseconds: 50) wait ].
kept := ByteArray new: 200000000.
(dir / ''grown'') ensureCreateFile.
(Delay forSeconds: ' , self targetLifetime printString , ') wait.
kept size.
Smalltalk exitSuccess'.
	[
	reader := LinuxProcessMemory on: pid.
	total := [ reader segments inject: 0 into: [ :sum :each | sum + each sizeInMemory ] ].
	before := reader whileStopped: total.
	(self spikeDirectory / 'grow') ensureCreateFile.
	self assert: (self waitFor: [ (self spikeDirectory / 'grown') exists ]) description: 'it never grew'.
	after := reader whileStopped: total.
	self
		assert: after - before > 150000000
		description: [ 'the second stop read the map of the first: ' , before printString , ' then ' , after printString ] ]
		ensure: [
			LibC system: 'kill -9 ' , pid printString.
			reader ifNotNil: [ reader close ] ]
