
Random{seed = 12345}

import("logo")

ls = LifeCycle{dim = 50, finalTime = 50}

ls:run()

ls.map:save("life-cycle.bmp")
clean()

