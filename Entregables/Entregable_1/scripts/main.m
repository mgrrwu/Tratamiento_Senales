close all

%agregar paths
addpath('../funciones', '../imagenes');


%cargar la imagen
%I=imread('oclusion.bmp');
I=imread('lena.bmp');
% mostrar la original
%figure
%imshow(I);

%% EJERCICIO 1
%Li=1; %conjunto de nivel inicial
%Lf=256;%conjunto de nivel final
%paso=50;%paso entre niveles
% 
% %Encuentro las lineas de nivel
% L=lineas_de_nivel(I, Li, Lf, paso);
% 
% 
% figure
% J=flip(I, 'v');%efectuo un flip vertical pues contour da vuelta la imagen
% [C, h]=contour(J);


%% EJERCICIO 2

% 1)primero ¿cual es el tamaño de la imagen de llegada?
% 2)encontrar la inversa de H
% 3)las coordenadas X=inv(H)*Xh
% 4)interpolacion para encontrar el nivel de gris de X
% y luego ese nivel de gris se asocia a Xh

%Transformaciones afines
%Cizallamiento
H1 = [1 0 0; .5 1 0; 0 0 1];
%Rotacion
theta=pi/4;
H2=[cos(theta) sin(theta) 0; -sin(theta) cos(theta) 0; 0 0 1];
%Composicion
H3=H1*H2;

%Proyectividad
H4=[1 2 1; 10 1 1; 0.01 0 1];

H5=[0.9 2 0; 0 1 100; 0.02 0.02 1];

H5=[0.9 2 0; 0 1 100; 0 0.0000002 1];

%Transformacion a efectuar
H=H5;

%

 
if det(H)~=0 %verifico que se pueda encontrar la inversa de H
    invH = pinv(H);%inversa de H
else
    error('La matriz de transformación debe tener un determinante distinto de cero')
end
 


[m,n]=size(I); %tamaño de la imagen
[x, y]=meshgrid(1:m, 1:n); %genero los indices para referenciar los pixeles
X=[x(:)  y(:) ones(m*n, 1)]';%las columnas son coordenadas homogeneas normalizadas de los indices de pixeles


%% Encuentro resolucion necesaria para contener el espacio de salida
Xh = H*X;
%normalizar los vectores homogeneos
Xh=homog_norm(Xh);
%Dejo las coordenadas mas pequeñas como el nuevo (0,0)

%corrimientos necesarios para traslacion de origen en el destino de manera
%que el menor pixel sea el ubicado en (1, 1)
dXh = min(Xh, [], 2);%minimo en cada fila de entre todas las columnas de Xh
xh=Xh(1,:)-dXh(1)+1; 
yh=Xh(2,:)-dXh(2)+1;

%tamaño de la imagen de salida
m_out=ceil(max(xh));%ceil efectua redondeo superior
n_out=ceil(max(yh));

%% Genero grilla de pixeles en el espacio de salida
r=1; %resolucion de la grilla, debe ser 1, si queremos mejorar la resolución de la salida debemos efectuar una interpolación luego de terminar el procesamiento.
[zx, zy]=meshgrid(1:r:m_out, 1:r:n_out);%genero los indices para referenciar los pixeles
Z=[zx(:)  zy(:) ones(length(zx(:)), 1)]';%grilla de coordenadas para la imagen de salida
Iout=uint8(zeros(1, size(Z,2)));%vector columna que contiene los pixeles de salida correspondientes a la grilla Z
%obtengo un mapeo de la grilla del espacio de salida en el espacio de llegada 
Z2=[Z(1,:)+dxh-1; Z(2,:)+dyh-1; Z(3,:)];
XX=invH*Z2;
XX=homog_norm(XX);
%% Con los valores de XX que se encuentren entre [1, m]x[1, n] efectúo la
%interpolación y adjudico valores a los pixeles del conjunto de salida

%colum_util contiene las columnas de XX que se encuentren entre [1, m]x[1, n]
colum_util=find((XX(1,:)>=1) &(XX(1,:)<=m) &(XX(2,:)>=1) &(XX(2,:)<=n));
%puntos de XX utiles
XX_util=XX(:,colum_util);


[I2, I3]=interpol_bilineal(I, XX_util);

%plotear(I, I3, 'Interpolador bilineal')
%pause
Iout(colum_util) = I2; 
Iout=matriz_imagen(Iout, Z);


plotear(I, Iout, 'Transformacion')


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PRUEBA DE LA INTERPOLACION BILINEAL 
%  [m n]= size(I);
%  [x,y] = meshgrid(1:n, 1:m);
%  r=3/10;
%  [p,q]=meshgrid(1:r:n, 1:r:m);
%  V=[p(:), q(:)]';
%  [I2, I3]=interpol_bilineal(I, V);
%  
%  plotear(I, I3, 'Interpolador bilineal')



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %PRUEBA DE LA INTERPOLACION VECINO MAS PROXIMO
% [m n]= size(I);
% [x,y] = meshgrid(1:n, 1:m);
% r=3/10;
% [p,q]=meshgrid(1:r:n, 1:r:m);
% V=[p(:), q(:)]';
% [I2, I3]=interpol_vecino(I, V);
% 
% plotear(I, I3, 'Interpolador vecino más cercano')







%remuevo los paths introducidos
rmpath('../funciones', '../imagenes');