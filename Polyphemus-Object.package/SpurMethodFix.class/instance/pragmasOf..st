fixing
pragmasOf: aCompilation

	"How a compilation prints its pragmas. They live in the state a method carries, which is
	the image's own and is kept, so a change to them is a change this cannot make."

	^ ([ aCompilation pragmas asArray ] on: Error do: [ :e | #(  ) ]) printString
