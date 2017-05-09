
Random{seed = 12345}

import("logo")

s = Schelling{dim = 50, finalTime = 1200}

s:run()

s.map:save("schelling.bmp")
clean()

