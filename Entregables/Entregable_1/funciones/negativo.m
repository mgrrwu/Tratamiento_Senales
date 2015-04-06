function J = negativo(I)
% J = negativo(I) realiza el negativo de una imagen en niveles 
% de gris. Devuelve otra imagen en niveles de gris
% 
%
I=double(I);

[M,N]=size(I);
for m=1:M
    for n=1:N
        J(m,n) = 255-I(m,n);
    end
end

J=uint8(J);

