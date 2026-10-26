helpers
valueIn: aName

	"The number a target wrote to the file aName (writing:as:), or nil. Replaced every few ms:
	between two versions there is none for an instant, so it is looked for a few times."

	| value |
	10 timesRepeat: [
		value ifNil: [
			value := [ (self spikeDirectory / aName) contents trimBoth asNumber ] on: Error do: [ :e | nil ].
			value ifNil: [ (Delay forMilliseconds: 20) wait ] ] ].
	^ value
