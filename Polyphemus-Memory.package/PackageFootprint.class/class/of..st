instance creation
of: anObjectMemory

	^ self new
		  setObjectMemory: anObjectMemory;
		  take;
		  yourself
