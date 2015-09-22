
Random{seed = 12345}

import("logo")

ls = LifeCycle{finalTime = 15}

ls:execute()

ls.map:save("life-cycle.bmp")
clean()

