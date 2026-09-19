reseting
resetResource
	<script>
	"Drop the resource and remove its generated class. A forgotten class keeps its loaded
	image, 82 MB, alive."

	currentImage ifNotNil: [ :resource |
		[ resource reset ] on: Error do: [ :e | ].
		[ resource removeFromSystem ] on: Error do: [ :e | ] ].
	currentImage := nil
