# This file was generated, do not modify it. # hide
@show fp(cm)                 # false positives
@show accuracy(ŷ, y)  |> r3
@show accuracy(cm)    |> r3  # same thing
@show precision(ŷ, y) |> r3
@show recall(ŷ, y)    |> r3
@show f1score(ŷ, y)   |> r3