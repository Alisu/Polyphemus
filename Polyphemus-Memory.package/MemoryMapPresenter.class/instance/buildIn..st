building
buildIn: aCanvas

	"The picture as one bitmap, its top left at the canvas' origin: a canvas point is a picture point."

	| bitmap controller |
	bitmap := RSBitmap new.
	bitmap form: self picture form.
	bitmap position: self picture form extent / 2.
	bitmap announcer when: RSMouseClick do: [ :event | self chooseAt: event position ] for: self.
	aCanvas add: bitmap.
	controller := RSCanvasController new.
	controller configuration
		maxScale: 64;
		minScale: 0.05.
	aCanvas addInteraction: controller
