accessing
largestClassIndex: anInteger

	"How large a class index is still believable. The field is 22 bits, so noise offers values
	up to four million while a real image has some tens of thousands of classes; refusing the
	rest is what makes a walk stop in noise almost at once instead of running for dozens of
	objects."

	largestClassIndex := anInteger
