testing
hasContextThatIs: aContext

	"Whether the context this frame is married to, where its field holds one, is that one."

	^ context notNil and: [ context = aContext ]
