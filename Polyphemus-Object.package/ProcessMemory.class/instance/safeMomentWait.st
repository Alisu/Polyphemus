holding it still
safeMomentWait

	"How long a stop outside a collection is looked for before a write or a reading is refused."

	^ safeMomentWait ifNil: [ 5 seconds ]
