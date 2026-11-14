instance creation
endingAt: aBaseFramePointer

	"Of a page whose oldest frame is known: the VM's record of it says where it is."

	^ self new setLimit: aBaseFramePointer baseIsKnown: true
