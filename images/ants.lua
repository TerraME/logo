
Random{seed = 12345}

import("logo")

ants = Ants{societySize = 40, rateEvaporation = 0.1, finalTime = 100}

ants:run()

ants.map:save("ants.bmp")
clean()

