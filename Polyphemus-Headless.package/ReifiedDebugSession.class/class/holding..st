instance creation
holding: aHeldImage

	"A session on what a held image was busy with, holding it until proceeded. Held but not read,
	the image is let go before the refusal shows: nobody has a handle on it yet (#181)."

	| context read |
	read := false.
	[
	context := aHeldImage process context.
	read := true ] valueThenLetGo: [ read ifFalse: [ aHeldImage letGo ] ].
	^ (self
		   named: 'Polyphemus'
		   on: nil
		   startedAt: context
		   fixing: nil)
		  stoppedBy: PolyphemusStop heldWhileRunning;
		  holding: aHeldImage;
		  yourself
