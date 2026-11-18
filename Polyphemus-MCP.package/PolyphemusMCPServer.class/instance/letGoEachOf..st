serving
letGoEachOf: someHeldReadings

	"Each let go in turn, the rest whatever that raises: a refusal is passed over, and an error of
	ours is shown once the others run on (#180)."

	someHeldReadings ifEmpty: [ ^ self ].
	[ [ someHeldReadings first session letTheImageGo ] on: PolyphemusError do: [ :refusal | nil ] ]
		ensure: [ self letGoEachOf: someHeldReadings allButFirst ]
