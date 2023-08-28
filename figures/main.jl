try
    using Plots
catch
    import Pkg
    Pkg.add("Plots")
    using Plots
end


include("ergodicity.jl")
include("diversificacionCooperativa.jl")
