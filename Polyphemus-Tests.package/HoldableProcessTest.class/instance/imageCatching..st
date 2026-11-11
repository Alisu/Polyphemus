helpers
imageCatching: somePriorities

	^ HeldImageCatchingPriorities new
		  setReader: (ProcessMemoryOfBytes on: (ByteArray new: 64) at: 16r1000) directory: nil;
		  priorities: somePriorities;
		  yourself
