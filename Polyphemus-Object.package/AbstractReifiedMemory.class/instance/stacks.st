contexts
stacks

	"What this reading says of the stacks of the image's processes (ReifiedStacks)."

	^ stacks ifNil: [ stacks := ReifiedStacks on: self ]
