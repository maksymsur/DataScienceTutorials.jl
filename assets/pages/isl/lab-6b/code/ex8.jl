# This file was generated, do not modify it. # hide
ŷ = predict(mtm, rows=test)
round(rms(ŷ, y[test]), sigdigits=4)