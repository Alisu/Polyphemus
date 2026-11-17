tests
testWhenItsInputEndsItLetsGoOfWhatItHolds

	"#180: a client that went away left each held image held until the agent's own limit."

	| asked |
	asked := OrderedCollection new.
	self heldBy: (self sessionNoting: asked).
	self heldBy: (self sessionNoting: asked).
	self server open: (PolyphemusMCPReading new setKind: 'image file' path: 'nowhere' reified: UnaskedDouble new) as: 'image'.
	self server serveFrom: (ReadStream on: '') to: (WriteStream on: String new).
	self assert: asked asArray equals: #( #letGo #letGo ).
	self assert: self server images isEmpty