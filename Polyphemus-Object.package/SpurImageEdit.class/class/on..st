instance creation
on: anImagePath

	^ self new setFile: (SpurImageFile on: anImagePath asFileReference)
