# check_value() doesn't offer duplicate suggestions

    Code
      check_value(c("a", "b"), c("Ars", "SEAMONITOR_ARRAY", "Siganid_Gulf_Aqaba"))
    Condition
      Error:
      x Can't find `value`: "a" and "b" in: "Ars", "SEAMONITOR_ARRAY", or "Siganid_Gulf_Aqaba"
      i Did you mean "Ars"?

