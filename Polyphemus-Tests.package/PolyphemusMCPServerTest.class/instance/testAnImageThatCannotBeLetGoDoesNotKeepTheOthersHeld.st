tests
testAnImageThatCannotBeLetGoDoesNotKeepTheOthersHeld

	"#180: when the input ends, each held image is let go whatever letting go of another raised, an
	error of ours included: it is shown once the others run on."

	| asked failing |
	asked := OrderedCollection new.
	failing := (DefectiveReadDouble of: Object new)
		           when: #letTheImageGo answer: [ asked add: #failed. 1 / 0 ];
		           yourself.
	self heldBy: failing.
	self heldBy: (self sessionNoting: asked).
	self heldBy: failing.
	self
		should: [ self server serveFrom: (ReadStream on: '') to: (WriteStream on: String new) ]
		raise: ZeroDivide.
	self assert: asked asBag equals: #( #failed #failed #letGo ) asBag
