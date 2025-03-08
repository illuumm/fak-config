let { tap, hold, td, combo, macro, ..} = import "fak/keycode.ncl" in
let util = import "fak/util_functions.ncl" in

let kc = tap.reg.kc in
let ks = tap.reg.ks in
let md = hold.reg.mod in
let tm = tap.reg.mod in
let lt = hold.reg.layer in
let fak = tap.custom.fak in
let me = tap.custom.media in
let XXXX = tap.none & hold.none in

let ki = {
  hp = { decision = 'hold, trigger_on = 'press },
  tp = { decision = 'tap, trigger_on = 'press },
  hr = { decision = 'hold, trigger_on = 'release },
  tr = { decision = 'tap, trigger_on = 'release },
  xx = { decision = 'none },
} in

let cto = 50 in
let virtual_keys' = [
	# LEFT
	combo.make cto [ 0,  1], # TAB,
	combo.make cto [19, 20], # ESC,
	combo.make cto [ 0,  9], # LCBR
	combo.make cto [ 1, 10], # LBRC
	combo.make cto [ 2, 11], # LPRN
	combo.make cto [20, 21], # V   
	combo.make cto [ 1,  2], # Q   
    #  RIGHT
	combo.make cto [ 6,  7], # BSPC
	combo.make cto [ 5, 14], # RPRN
	combo.make cto [ 6, 15], # RBRC
	combo.make cto [ 7, 16], # RCBR
  combo.make cto [23, 24]  # ENT
	] in
	
let virtual_key_count = std.array.length virtual_keys' in
let key_count = 28 + virtual_key_count in
	
let layouts = {
  APTMAK = "WFPBJLUYRSTHKXNAIOZCGDM,.;",
  BIRD =   "CLFPJYOURSNTBKHEIAXWMGD,.;",
} in

let make_hrm = fun key_idx =>
  let htb_hrm_base = fun eager => {
    timeout_ms = 180,
    # quick_tap_ms = 100,
    # quick_tap_interrupt_ms = 500,
    # global_quick_tap_ms = 80,
    eager_decision = eager,
    timeout_decision = 'hold,
  } in

  let virtual_interrupts = std.array.replicate virtual_key_count ki.hr in

  let htb_hrm_left = fun eager => htb_hrm_base eager & {
    key_interrupts = [
             ki.tp, ki.tp, ki.tp, ki.tp,    ki.hr, ki.hr, ki.hr, ki.hr,
      ki.tr, ki.tr, ki.tr, ki.tr, ki.tr,    ki.hr, ki.hr, ki.hr, ki.hr, ki.hr,
      ki.tp, ki.tp, ki.tp, ki.tp,                  ki.hr, ki.hr, ki.hr, ki.hr,
                                  ki.hr,    ki.hr
    ] @ virtual_interrupts
  } in

  let htb_hrm_right = fun eager => htb_hrm_base eager & {
    key_interrupts = [
             ki.hr, ki.hr, ki.hr, ki.hr,    ki.tp, ki.tp, ki.tp, ki.tp,       
      ki.hr, ki.hr, ki.hr, ki.hr, ki.hr,    ki.tr, ki.tr, ki.tr, ki.tr, ki.tr,
      ki.hr, ki.hr, ki.hr, ki.hr,                  ki.tp, ki.tp, ki.tp, ki.tp,
                                  ki.hr,    ki.hr
    ] @ virtual_interrupts
  } in

  let hrm_mods = [
    md.lsft, md.lgui, md.lalt, md.lctl, md.ralt,
    md.ralt, md.rctl, md.lalt, md.rgui, md.rsft,
  ] in

  let hrm_key_indices = [8, 9, 10, 11, 12, 13, 14, 15, 16, 17] in

  if std.array.elem key_idx hrm_key_indices then
    let mod_idx = util.array.index_of key_idx hrm_key_indices in
    let side = if mod_idx < (std.array.length hrm_mods / 2) then 'left else 'right in
    let mod = std.array.at mod_idx hrm_mods in

    mod & hold.reg.behavior (
      (if side == 'left then htb_hrm_left else htb_hrm_right)
      (if mod == md.lgui || mod == md.lalt || mod == md.rgui || mod == md.ralt then 'none else 'hold)
    )
  else
    {}
in

let alphas = fun layout => layout
  |> std.string.characters
  |> util.array.enumerate
  |> std.array.map (
      fun { index, value } => kc."%{value}"
      & make_hrm index
    )
in

let thumb = fun thumb_idx =>
  let thumb_behavior = {
    timeout_ms = 180,
    timeout_decision = 'hold,
    key_interrupts = std.array.replicate key_count ki.hr,
  } in
  [
    kc.SPC  & lt 1 & hold.reg.behavior thumb_behavior,
    kc.E    & lt 2 & hold.reg.behavior thumb_behavior, 
  ]
  |> std.array.at thumb_idx
in

let cu = {
  # copy custom stuff from example
  COPY = md.lctl & kc.INS, # md.lctl & kc.C,
  PSTE = md.lsft & kc.INS, # md.lctl & kc.V,
  CUT  = md.lctl & kc.X,
} in

let combos_base = [
  kc.TAB, kc.ESC, ks.LCBR, kc.LBRC, ks.LPRN, kc.V, kc.Q,
  kc.BSPC, ks.RPRN, kc.RBRC, ks.RCBR, kc.ENT
] in

{
  virtual_keys = virtual_keys',
  layers = [
    let base = fun key_idx => (alphas layouts.APTMAK) |> std.array.at key_idx in
    # ALPHAS
    [
               base 0,  base 1,  base 2,  base 3,  base 4,  base 5,  base 6,  base 7,
      base 8,  base 9,  base 10, base 11, base 12, base 13, base 14, base 15, base 16, base 17,
      base 18, base 19, base 20, base 21,                   base 22, base 23, base 24, base 25,
                                          thumb 0, thumb 1,
    ] @ combos_base,
    # SYM NUM
    [
               kc.F9,   kc.F10,  kc.F11,  kc.F12,         ks.PLUS, kc.N7,   kc.N8,  kc.N9,
      kc.F5,   kc.F6,   kc.F7,   kc.F8 ,  fak.BOOT,       kc.MINS, kc.N4,   kc.N5,  kc.N6,  kc.N0,
      kc.F1,   kc.F2,   kc.F3,   kc.F4,                   kc.N1,   kc.N2,  kc.N3,  kc.DOT,
                                             XXXX,        XXXX,
    ] @ combos_base,
    # NAV
    [
               
               
               
               kc.SLSH, kc.EQL,  kc.BSLS, kc.GRV,         XXXX,    kc.PGDN, kc.UP,   kc.PGUP,
      ks.AMPR, ks.EXLM, ks.PLUS, ks.UNDS, ks.HASH,        kc.HOME, kc.LEFT, kc.DOWN, kc.RGHT,  kc.END,
      ks.PIPE, ks.QUES, kc.MINS, ks.ASTR,                             XXXX,    XXXX,    XXXX,  XXXX,
                                          XXXX,           XXXX, 
    ] @ combos_base,
  ]
}