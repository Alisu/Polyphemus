protocol
schema: aType saying: aDescription

	^ Dictionary new
		  at: 'type' put: aType;
		  at: 'description' put: aDescription;
		  yourself
