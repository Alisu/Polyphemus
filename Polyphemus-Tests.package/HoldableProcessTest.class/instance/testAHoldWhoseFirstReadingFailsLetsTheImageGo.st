tests
testAHoldWhoseFirstReadingFailsLetsTheImageGo

	"#181: held, then not read (a damaged class table, an agent that stopped answering): nobody has
	a handle on the image by then, so it is let go before the refusal is shown, and the refusal is."

	| image |
	image := HeldImageWhoseReadingFails new.
	self should: [ ReifiedDebugSession holding: image ] raise: NotInTheReading.
	self assert: image wasLetGo
