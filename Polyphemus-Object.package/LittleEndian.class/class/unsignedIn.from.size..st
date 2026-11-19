reading
unsignedIn: someBytes from: anIndex size: aCount

	"The unsigned integer of aCount bytes starting at anIndex, which counts from one."

	| value |
	value := 0.
	anIndex + aCount - 1 to: anIndex by: -1 do: [ :index | value := (value bitShift: 8) + (someBytes at: index) ].
	^ value
