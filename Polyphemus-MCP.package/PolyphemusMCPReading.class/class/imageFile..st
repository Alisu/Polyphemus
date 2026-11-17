instance creation
imageFile: aPath

	"An image file, checked as readImageFile: checks one and loaded; its objects are reified when
	first asked for, a census needing none of them."

	^ self new setImageFile: aPath
