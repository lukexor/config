-- Change the default Omarchy look'n'feel.
-- See https://wiki.hypr.land/Configuring/Basics/Variables/

hl.config({
  general = {
    gaps_in = 2,
    gaps_out = 4,
  },

  master = {
    mfact = 0.6,

    -- New windows land on top of the stack, so closing one leaves the most
    -- recent window active.
    new_on_top = true,
  },
})
