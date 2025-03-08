let { ColToRowKey, .. } = import "fak/keyboard.ncl" in
let { CH552T, .. } = import "fak/mcus.ncl" in

{
  mcu = CH552T,
  matrix = {
    cols = [30, 34, 31, 11, 16 ],
    rows = [10, 35, 33, 15, 14, 32]
  },
  usb_dev = {
    vendor_id = 43962, # 0xABBA
    product_id = 5665,
    product_ver = 1.0, # 0x0100
  },
  keys =
    let M = ColToRowKey in
    [
             M 1 0, M 2 0, M 3 0, M 4 0,    M 4 3, M 3 3, M 2 3, M 1 3,
      M 0 1, M 1 1, M 2 1, M 3 1, M 4 1,    M 4 4, M 3 4, M 2 4, M 1 4, M 0 4,
      M 0 2, M 1 2, M 2 2, M 3 2,                  M 3 5, M 2 5, M 1 5, M 0 5,
                                  M 4 2,    M 4 5,
    ]
}
