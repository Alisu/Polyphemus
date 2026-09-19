tests
testEveryContextMarriedToAFrameIsEnumerated

	"#8: contexts in eden were readable by address but missing from new space's objects,
	because the walk by shape stops where past space's survivors end."

	| raw young married |
	raw := memory vmLayout raw.
	young := Set new.
	raw youngObjectsDo: [ :each | young add: each ].
	married := self allFrames select: [ :each | each oopFlag isMarried ].

	self assert: married notEmpty.
	married do: [ :each |
		| address |
		address := each oopContext address.
		(address between: raw youngSpaceStart and: raw heapStart) ifTrue: [
			self assert: (young includes: address) ] ]
