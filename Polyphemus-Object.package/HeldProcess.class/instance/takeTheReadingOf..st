initialization
takeTheReadingOf: aHeldProcess

	"Read next as a step reads: taking that hold's classes over, when nothing moved them since,
	rather than reading the image whole again (#114)."

	heldReading takeTheReadingOf: aHeldProcess heldReading
