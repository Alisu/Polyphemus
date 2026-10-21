tests
testItLetsGoOnceWhenAllGoesWell

	| lettings |
	lettings := 0.
	self assert: ([ 42 ] valueThenLetGo: [ lettings := lettings + 1 ]) equals: 42.
	self assert: lettings equals: 1
