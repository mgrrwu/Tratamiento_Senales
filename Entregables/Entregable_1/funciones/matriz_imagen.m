function Iout=matriz_imagen(I, X)
%Funcion que genera la matriz de pixeles a partir de vectores pixeles I y
%las respectivas coordenadas X

x=X(1,:);
y=X(2,:);

mm=max(x);
nn=max(y);
Iout=zeros(mm, nn);%inicializo la variable de salida

for k=1:length(I)%genero una matriz imagen en lugar de tener un vector de pixeles
    Iout(x(k), y(k))=I(k);
end