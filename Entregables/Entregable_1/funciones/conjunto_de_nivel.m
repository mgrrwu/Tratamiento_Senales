function [X, lambda_max, lambda_min]=conjunto_de_nivel(I)

%Función que devuelve en la estructura X los conjuntos de nivel superior de una imagen I


lambda_max = max(max(I));
lambda_min = min(min(I));

X =struct('data',{},'lambda',{});
I=256-I;
for i=1:257
lambda = i-1;
X(i).data = I>=lambda;
X(i).lambda = lambda;
end