function J=transformar(I, H, interpol)

 
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
xh=Xh(1,:);
yh=Xh(2,:);
%corrimientos necesarios para traslacion de origen en el destino de manera
%que el menor pixel sea el ubicado en (1, 1)
dxh=min(xh);
dyh=min(yh);
xh=xh-dxh+1; 
yh=yh-dyh+1;

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
colum_util=find((XX(1,:)>1) &(XX(1,:)<m) &(XX(2,:)>1) &(XX(2,:)<n));
%puntos de XX utiles
XX_util=XX(:,colum_util);


[I2, I3]=interpol_bilineal(I, XX_util);

%plotear(I, I3, 'Interpolador bilineal')
%pause
Iout(colum_util) = I2; 
Iout=matriz_imagen(Iout, Z);
