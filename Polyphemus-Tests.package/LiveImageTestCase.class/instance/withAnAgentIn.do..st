helpers
withAnAgentIn: aPid do: aBlock

	"Hold the image, hand it the agent, and give aBlock a channel to it and the reader; kill
	the image afterwards. The agent's bell is the word that releases the hold."

	| reader channel |
	channel := DirectoryChannel on: self spikeDirectory / 'channel'.
	[
	reader := LinuxProcessMemory on: aPid.
	self holdWithTheInterrupt: reader.
	self askTheHeldImageTo: (PolyphemusAgent
			 sourceServing: channel directory
			 bell: (PolyphemusAgent semaphoreAt: self watcherSemaphoreIndex)).
	channel ringing: [ reader whileStopped: [ self letGo: reader ] ].
	reader whileStopped: [ self letGo: reader ].
	aBlock cull: channel cull: reader ] ensure: [
		LibC system: 'kill -9 ' , aPid printString.
		reader ifNotNil: [ reader close ] ]
