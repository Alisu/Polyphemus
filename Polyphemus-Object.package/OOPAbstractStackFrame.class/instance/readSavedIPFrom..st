update
readSavedIPFrom: aFrameAbove

	"Below a frame, our saved ip is kept by the frame above (#frameCallerSavedIP:, #10)."

	savedIP := self layout wordAt: aFrameAbove framePointer + memory wordSize