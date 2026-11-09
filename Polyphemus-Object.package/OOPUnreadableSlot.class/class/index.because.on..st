instance creation
index: anIndex because: aString on: aMemory

	^ self new
		  setIndex: anIndex reason: aString;
		  memory: aMemory;
		  yourself
