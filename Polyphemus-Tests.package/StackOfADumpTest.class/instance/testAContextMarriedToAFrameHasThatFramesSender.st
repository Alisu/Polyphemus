tests
testAContextMarriedToAFrameHasThatFramesSender

	"#215: a context married to a frame ended a walk down the senders, the frames below unread.
	Its sender is its frame's, as a walk of the frames finds it."

	| married where |
	married := self allFrames select: [ :each | each oopFlag isMarried ].
	self assert: married notEmpty.
	where := [ :activation | activation ifNotNil: [ activation activationAddress ] ].
	self assert: (married anySatisfy: [ :each | each sender notNil ]).
	married do: [ :each | self assert: (where value: each oopContext sender) equals: (where value: each sender) ]
