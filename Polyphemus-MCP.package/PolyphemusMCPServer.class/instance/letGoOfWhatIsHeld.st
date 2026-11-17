serving
letGoOfWhatIsHeld

	"Every held image runs on and every handle is forgotten: a client that went away would leave
	them held until the agent's own limit. One that cannot be let go does not keep the others."

	| held |
	held := self images values select: [ :each | each isHeld ].
	images := nil.
	held do: [ :each | [ each session letTheImageGo ] on: PolyphemusError do: [ :refusal | nil ] ]