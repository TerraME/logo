
Random{seed = 12345}

import("logo")

gs = GrowingSociety{finalTime = 15}

gs:execute()

gs.map:save("growing-society.bmp")
clean()

