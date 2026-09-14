reseting
resetResource
	<script>
	"Drop the resource, and the class it was.

	#currentImage builds its resource with #newSubclass, which makes a brand new class
	every time -- Pharo10ImageResource1, 2, 3 and on -- and each one keeps a loaded image
	alive through TestResource's class side. Forgetting the class rather than removing it
	leaks 82 MB a reset: ten had piled up and the image on disk had grown from 80 MB to
	896 MB."

	currentImage ifNotNil: [ :resource |
		[ resource reset ] on: Error do: [ :e | ].
		[ resource removeFromSystem ] on: Error do: [ :e | ] ].
	currentImage := nil
