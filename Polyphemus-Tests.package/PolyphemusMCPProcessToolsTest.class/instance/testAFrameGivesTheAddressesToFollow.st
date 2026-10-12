tests
testAFrameGivesTheAddressesToFollow

	"An object in a frame comes with its address, so inspect can take it from there."

	| frame |
	frame := self frameRunning: 'SessionManager>>snapshot:andQuit:' in: self resource target.
	self assert: (frame at: 'receiverAddress') isInteger.
	self assert: (((self inspect: (frame at: 'receiverAddress') in: self resource target) at: 'structuredContent') at: 'class') equals: 'SessionManager'
