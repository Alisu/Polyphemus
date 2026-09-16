instance creation
forClassIndex: anIndex at: anAddress on: aMemory

	^ self new
		  setClassIndex: anIndex;
		  address: anAddress;
		  memory: aMemory;
		  yourself
