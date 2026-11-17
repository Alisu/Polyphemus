instance creation
holding: aHeldImage

	"A session on what a held image was busy with, holding it until proceeded: steps are taken
	there, a method accepted is fixed there, proceeding lets it go."

	^ (self
		   named: 'Polyphemus'
		   on: nil
		   startedAt: aHeldImage process context
		   fixing: nil)
		  stoppedBy: PolyphemusStop heldWhileRunning;
		  holding: aHeldImage;
		  yourself