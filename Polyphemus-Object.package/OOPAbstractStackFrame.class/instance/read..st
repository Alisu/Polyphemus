private
read: aBlock

	"aBlock's value, something of this frame read through its layout; nil when the reading
	refuses it. What is nil for that is refused by name when asked for (#198)."

	^ aBlock on: PolyphemusError do: [ :refusal | nil ]
