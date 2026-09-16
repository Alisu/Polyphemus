The class of an object whose class cannot be read.

Not the same thing as `OOPAbnormalEntity`, which stands for a stretch of bytes that may not be
objects at all and can only guess. An object whose class index answers nothing is not a guess: its
header is sound, its format is sound, its slots are readable. Everything about it is known except
its name.

So it keeps the class index it could not resolve, and says so. An object is not hidden because we
cannot name it.
