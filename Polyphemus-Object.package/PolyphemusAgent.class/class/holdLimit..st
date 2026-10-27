settings
holdLimit: aDurationOrNil

	"Taken by the holds that start afterwards; nil holds for ever."

	HoldLimit := aDurationOrNil ifNil: [ #never ]
