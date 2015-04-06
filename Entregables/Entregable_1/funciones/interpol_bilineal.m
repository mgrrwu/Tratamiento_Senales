function [Iout, Iout2]=interpol_bilineal(I, X)

%Funcion que realiza la interpolacion bilineal de una imagen I 
%para encontrar los valores de los pixeles Iout con coordenadas X

%% ENTRADA
%I -->imagen a interpolar
%X -->puntos donde se desea obtener un valor de pixel

%% SALIDA
%Iout -->vector columna que indica el valor de pixel correspondiente a cada par de coordenadas de X
%Iout2 -->matriz de pixeles 


%% CUERPO DE LA FUNCION
%coordenadas x e y de la entrada
x=X(1,:);
y=X(2,:);

i=round(x);%fila del pixel entero
j=round(y);%columna de pixel entero
%distancias del punto a evaluar con el pixel entero 
a=x-i;
b=y-j;

[m, n]=size(I);%resolución de la imagen de entrada
I=double(I); %llevo los valores uint8 a double
%resuelvo los posibles indices que se salen de la imagen
i(i>=m)=m-1;
j(j>=n)=n-1;

%% Calculo el valor de los pixeles interpolados
%para acceder al valor (i,j) de I se puede hacer I(i, j) o equivalentemente I(m.*(j-1)+i)!!!!!
%donde [m,n]=size(I)
uij  =I(m.*(j-1)+i);
ui1j =I(m.*(j-1)+i+1);
uij1 =I(m.*(j)+i);
ui1j1=I(m.*(j)+i+1);
%Utilizo cuentas matriciales para hacer la iteracion
Iout=(1-a).*(1-b).*uij +a.*(1-b).*ui1j +(1-a).*b.*uij1 +a.*b.*ui1j1;

%Obtencion de la matriz imagen de salida

%se intenta encontrar el minimo paso r entre valores sucesivos, si el mismo se mantiene constante el resultado de la matriz imagen es optimo
r=abs(X(1, 2:end)- X(1, 1:end-1)) ;
r=r(r~=0);%quito ceros
r=r(r>0.001);%quito valores muy pequeños
r=min(r);
if r>1
    r=1;
end

Xn=floor(X./r);%de esta manera obtengo indices enteros

%Iout2 = matriz_imagen(Iout, Xn);
 mm=(max(Xn(1,:)));
 nn=(max(Xn(2,:)));
 Iout2=zeros(mm, nn);
 for k=1:length(Iout)%genero una matriz imagen en lugar de tener un vector de pixeles
     Iout2(Xn(1,k), Xn(2,k))=Iout(k);
 end
Iout = uint8(Iout);
Iout2 = uint8(Iout2);