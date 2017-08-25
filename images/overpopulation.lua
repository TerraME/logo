
Random{seed = 12345}

import("logo")

over = Overpopulation{dim = 50, finalTime = 50}

over:run()

over.map:save("overpopulation.bmp")
clean()

