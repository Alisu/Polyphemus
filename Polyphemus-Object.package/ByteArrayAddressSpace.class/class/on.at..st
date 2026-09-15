instance creation
on: aByteArray at: anAddress

	^ self new
		  setBytes: aByteArray at: anAddress;
		  yourself
