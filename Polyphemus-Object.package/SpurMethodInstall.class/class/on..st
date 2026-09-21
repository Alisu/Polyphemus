instance creation
on: aReifiedMemory

	"An installer for that reading: what it allocates and stores goes into the memory VMMaker
	loaded the image into, and the image is written from there."

	^ self new
		  setReading: aReifiedMemory;
		  yourself
