helpers
withAnAgentIn: aPid do: aBlock

	"Hold the image, hand it the agent, and give aBlock a channel to it and the reader; kill
	the image afterwards. The agent's bell is the word that releases the hold."

	| reader channel signals |
	channel := DirectoryChannel on: self spikeDirectory / 'channel'.
	[
	reader := LinuxProcessMemory on: aPid.
	self holdWithTheInterrupt: reader.
	self askTheHeldImageTo: (PolyphemusAgent sourceServing: channel directory).
	signals := reader whileStopped: [
		           self excessSignalsOfTheInterruptSemaphoreIn: (SpurDumpedMemory on: reader) raw ].
	channel ringing: [ reader whileStopped: [ reader storeWord: 1 * 8 + 1 at: signals ] ].
	reader whileStopped: [ reader storeWord: 1 * 8 + 1 at: signals ].
	aBlock cull: channel cull: reader ] ensure: [
		LibC system: 'kill -9 ' , aPid printString.
		reader ifNotNil: [ reader close ] ]
