event-handling
enableInspectOnClickForBox: box
	"On the announcer, naming the subscriber: Pharo 12's Roassal deprecates when:do: without one,
	and Pharo 10's has no when:do:for: on a shape."
	box announcer when: RSMouseLeftClick do: [ :rso | rso shape model inspect ] for: self.
	^ box