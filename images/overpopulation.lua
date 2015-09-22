
Random{seed = 12345}

import("logo")

over = Overpopulation{finalTime = 15}

over:execute()

over.map:save("overpopulation.bmp")
clean()

