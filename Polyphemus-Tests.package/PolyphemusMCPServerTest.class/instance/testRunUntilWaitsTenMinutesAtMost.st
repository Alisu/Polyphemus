tests
testRunUntilWaitsTenMinutesAtMost

	"#180: the server answers nothing while it waits; the seconds asked for have a ceiling, and
	are a number above zero."

	| asked handle |
	asked := OrderedCollection new.
	handle := self heldBy: (self sessionNoting: asked).
	{ 100000 -> 600. 5 -> 5. 0 -> 1. 'soon' -> nil } do: [ :each |
		| result |
		asked removeAll.
		result := self resultOf: 'run_until' with: (Dictionary new
				           at: 'handle' put: handle;
				           at: 'method' put: 'Object >> #yourself';
				           at: 'seconds' put: each key;
				           yourself).
		each value
			ifNil: [
				self assert: (result at: 'isError').
				self assert: (((result at: 'content') first at: 'text') includesSubstring: 'seconds').
				self assert: asked isEmpty ]
			ifNotNil: [ :seconds | self assert: asked first value equals: seconds seconds ] ]