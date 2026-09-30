instance creation
on: anObjectMemory

	^ self basicNew
		  setObjectMemory: anObjectMemory;
		  initialize;
		  yourself
