using Random
using Plots

delta_expected = 1.5*0.5+0.6*0.5 - 1 # <\Delta x>
time_average = log(1.5)*0.5+log(0.6)*0.5 # <\Delta ln x>

function game(n=10,d=1,t=1000, seed=1; costo = 0.0)
    Random.seed!(seed)
    res = zeros((n,t+1))
    res[:,1] .= 1.0
    for i in 2:(t+1)#i=2
        cpr = (sum(res[1:(n-d),i-1].*(1-costo))/n)        
        for a in 1:n#a=1
            if rand([0,1]) == 0
                res[a,i] = a<=(n-d) ? cpr*1.5 : (cpr+res[a,i-1])*1.5
            else
                res[a,i] = a<=(n-d) ? cpr*0.6 : (cpr+res[a,i-1])*0.6
            end
        end
    end
    return res
end

############################
# PROMEDIO DE ESTADOS (DILEMA)

propio = 1.0
n = 100
cooperar = []
desertar = []
costo = 0.0

for n_desertores in 0:(n)
    reparto = ((n-n_desertores)*propio*(1-costo)/n)    
    push!(desertar,(reparto + propio) *1.5*0.5 + (reparto  + propio)*0.6*0.5 )
    push!(cooperar, (reparto) *1.5*0.5 + (reparto)*0.6*0.5)
end

all(cooperar.<desertar)

dilema_estados = [ [cooperar[1]-1 cooperar[end-1]-1] 
                   [desertar[2]-1 desertar[end]-1] ]

dilema_temporal = [ [cooperar[1]-1 cooperar[end-1]-1] 
                    [cooperar[2]-1 log(1.5)*0.5+log(0.6)*0.5] ]
           
# end PROMEDIO DE ESTADOS (DILEMA)
##################################

h=game(33,33,2000,9)
ylim = (log(minimum(h)),log((1+delta_expected)^2000))

p = plot(log.(transpose(h)),legend = false, thickness_scaling = 1.5, grid=false,  ylim = ylim)
plot!([1,2000],log.([1.0,(1+delta_expected)^2000 ]), color="black")
plot!([1,2000],log.([1.0,(1+time_average)^2000]), color="black")

savefig(p, "cpr_individual.pdf") 

p = plot(log.(transpose(game(1,1,10,9))),legend = false, thickness_scaling = 1.5, grid=false)
plot!(log.([ sum(c)/length(c) for c in eachcol(game(10,10,10,9))]))
plot!(log.([ sum(c)/length(c) for c in eachcol(game(100,100,10,9))]))
plot!(log.([ sum(c)/length(c) for c in eachcol(game(1000,1000,10,9))]))
plot!(log.([ sum(c)/length(c) for c in eachcol(game(10000,10000,10,9))]), color="black")

savefig(p, "cpr_individual_media_estados.pdf") 

p = plot(log.(game(100,0,2000)[1,:]),legend = false, color="green", thickness_scaling = 1.5, grid=false, ylim = ylim,linewidth=2.5)
plot!([1,2000],log.([1.0,(1+delta_expected)^2000 ]), color="black")
plot!([1,2000],log.([1.0,(1+time_average)^2000]), color="black")

savefig(p, "cpr_cooperation.pdf") 

p = plot(log.(transpose(game(100,0,2000))),legend = false, color="green", thickness_scaling = 1.5, grid=false, ylim = ylim)
plot!(log.(transpose(game(100,1,2000))),legend = false, color="blue")
plot!(log.(transpose(game(100,10,2000))),legend = false, color="red")
#plot!([1,2000],log.([1.0,(1+delta_expected)^2000 ]), color="black")
#plot!([1,2000],log.([1.0,(1+time_average)^2000]), color="black")

savefig(p, "cpr_cooperation_defection.pdf") 

p = plot(log.(transpose(game(10,0,10,1))), legend = false, color="green",thickness_scaling = 1.5, grid=false)
plot!(log.(transpose(game(10,1,10,1))), legend = false, color="blue")
plot!(log.(transpose(game(10,2,10,1))), legend = false, color="red")

savefig(p, "cpr_cooperation_defection_zoom.pdf") 

p = plot(log.(transpose(game(100,0,2000,costo=0.01))),legend = false, color="green", thickness_scaling = 1.5, grid=false, ylim = ylim)
plot!(log.(transpose(game(100,1,2000,costo=0.01))),legend = false, color="blue")
plot!(log.(transpose(game(100,10,2000,costo=0.01))),legend = false, color="red")

savefig(p, "cpr_cooperation_defection_costo.pdf") 


#######################

function dilema(n=100,d=1,t=1000, b=2, c=1)
    res = zeros((n,t+1))
    res[:,1] .= 0.0
    for i in 2:(t+1)#i=2
        cpr = sum(b*(n-d))/n
        for a in 1:n#a=1
            res[a,i] = res[a,i-1] + cpr - (a<=(n-d) ? c : 0)
        end
    end
    return res
end

sum(dilema(10,0)[:,end])
sum(dilema(10,1)[:,end])
sum(dilema(10,2)[:,end])

p = plot(transpose(dilema(10,0)),legend=false, color="green")
plot!(transpose(dilema(10,1)),legend=false, color="blue")
plot!(transpose(dilema(10,2)),legend=false, color="red")

savefig(p, "cpr_prisioner_dilema.pdf") 

#####################################
# Simulacion pescadores

function ontogeneticGrowth(t, m0=0.0, a=0.08, M = 1000.1)
    return (1 - (1 - ( (m0/M)^(1/4) ))*exp(-(a*t)/(4*M^(1/4))))^4
end

#plot(ontogeneticGrowth.(1:2000),legend=false)

function sigmoidea(t, beta=0.1, alpha=50)
    return 1/(1+exp(beta*(-t+alpha)))
end

function age(m0, M, beta=0.1, alpha=50.0 )
    return alpha - log( (M/m0) - 1 )*10
end

poblaciones = []

for explotacion in 1:100
    poblacion = [1000.0,990.0]
    tot = 1000.0
    while (abs(poblacion[end]-poblacion[end-1]) > 0.01) 
        pop = poblacion[end]-explotacion 
        if pop >= 0.0
            pop = sigmoidea(age(pop,tot)+1)*tot
        else
            pop = 0.0
        end
        push!(poblacion , pop)
    end
    push!(poblaciones,poblacion)
end

maximum([length(p) for p in poblaciones])
sum([p[end] for p in poblaciones].>0.0)
poblaciones[20]

# Concluisones
# Si son 5 y sacan 5 cada uno, sacan infinita cantidad de peces en el tiempo
# Si uno empieza a sacar 6, sacan 277*6


