using Plots
using Random

Random.seed!(1)

prior = 1/2
datos = [ rand(1:3) == 1 ? 0 : 1  for i in 1:(2^5)]
predicciones_A = [ (1/3)^(1-d) * (2/3)^d  for d in datos ] # Por el regalo
predicciones_B = [ 1/2  for d in datos ] # Por el regalo

predicciones_A.*1/2 # Por la pista
predicciones_A.*1/3 # Por la pista

evidencia_A = cumprod(predicciones_A )
evidencia_B = cumprod(predicciones_B )

p_datos = evidencia_A.*prior .+ evidencia_B.*prior
p_modelo_A = evidencia_A .* prior ./ p_datos 

p = plot([0.5; p_modelo_A], ylim=[0,1], ylab="P(M | D)", xlab="Cantidad de datos"  ,thickness_scaling = 1.5, grid=false,  label="Modelo B", legend=(25.0, 0.5))
plot!(1.0.-[0.5; p_modelo_A], label="Modelo A")

savefig(p, "monty_hall_selection.pdf") 

