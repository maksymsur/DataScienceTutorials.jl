# Before running this, please make sure to activate and instantiate the environment
# corresponding to [this `Project.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Project.toml) and [this `Manifest.toml`](https://raw.githubusercontent.com/alan-turing-institute/DataScienceTutorials.jl/master/Manifest.toml)
# so that you get an environment which matches the one used to generate the tutorials:
#
# ```julia
# cd("DataScienceTutorials") # cd to folder with the *.toml
# using Pkg; Pkg.activate("."); Pkg.instantiate()
# ```

using MLJ
using StableRNGs
import DataFrames

@load RidgeRegressor pkg=MultivariateStats

rng = StableRNG(6616) # for reproducibility
x1 = rand(rng, 300)
x2 = rand(rng, 300)
x3 = rand(rng, 300)
y = exp.(x1 - x2 -2x3 + 0.1*rand(rng, 300))
X = DataFrames.DataFrame(x1=x1, x2=x2, x3=x3)

test, train = partition(eachindex(y), 0.8);

Xs = source(X)
ys = source(y, kind=:target)

std_model = Standardizer()
stand = machine(std_model, Xs)
W = transform(stand, Xs)

box_model = UnivariateBoxCoxTransformer()
box = machine(box_model, ys)
z = transform(box, ys)

ridge_model = RidgeRegressor(lambda=0.1)
ridge = machine(ridge_model, W, z)
ẑ = predict(ridge, W)

ŷ = inverse_transform(box, ẑ)

@from_network CompositeModel(std=std_model, box=box_model,
                             ridge=ridge_model) <= ŷ;

cm = machine(CompositeModel(), X, y)
res = evaluate!(cm, resampling=Holdout(fraction_train=0.8, rng=51),
                measure=rms)
round(res.measurement[1], sigdigits=3)

mutable struct CompositeModel2 <: DeterministicNetwork
    std_model::Standardizer
    box_model::UnivariateBoxCoxTransformer
    ridge_model::RidgeRegressor
end

function MLJ.fit(m::CompositeModel2, verbosity::Int, X, y)
    Xs = source(X)
    ys = source(y, kind=:target)
    W = transform(machine(m.std_model, Xs), Xs)
    box = machine(m.box_model, ys)
    z = transform(box, ys)
    ẑ = predict(machine(m.ridge_model, W, z), W)
    ŷ = inverse_transform(box, ẑ)
    fit!(ŷ, verbosity=0)
    return fitresults(ŷ)
end

mdl = CompositeModel2(Standardizer(), UnivariateBoxCoxTransformer(),
                      RidgeRegressor(lambda=0.1))
cm = machine(mdl, X, y)
res = evaluate!(cm, resampling=Holdout(fraction_train=0.8), measure=rms)
round(res.measurement[1], sigdigits=3)

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

