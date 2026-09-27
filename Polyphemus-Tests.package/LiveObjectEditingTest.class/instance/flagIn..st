helpers
flagIn: aSession

	"Reached as in an inspector, through the block Interval>>do: runs, which copied it."

	^ ((aSession interruptedContext findContextSuchThat: [ :each | each selector = #do: ])
		   tempNamed: 'aBlock') reifiedSlotAt: 5
