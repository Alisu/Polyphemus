helpers
withAnAgentIn: aPid do: aBlock

	"Hold the image, hand it the agent, and give aBlock a channel to it and the reader; kill
	the image afterwards."

	| reader channel |
	channel := DirectoryChannel on: self spikeDirectory / 'channel'.
	[
	reader := LinuxProcessMemory on: aPid.
	self holdWithTheInterrupt: reader.
	self askTheHeldImageTo: (PolyphemusAgent sourceServing: channel directory).
	reader whileStopped: [ self letGo: reader heap: (SpurDumpedMemory on: reader) raw ].
	aBlock cull: channel cull: reader ] ensure: [
		LibC system: 'kill -9 ' , aPid printString.
		reader ifNotNil: [ reader close ] ]
