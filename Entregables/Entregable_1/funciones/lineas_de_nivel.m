function L=lineas_de_nivel(I, Li, Lf, paso)

%Funcion que calcula y despliega las líneas de nivel de una imagen 

%% Entrada
%I  --> Imagen de entrada 
%Li --> Conjunto de nivel inicial
%Lf --> Conjunto de nivel final
%paso --> Cuantos pasos se toman entre los niveles a comparar
 
%% Salida
%L --> imagen con las lineas de nivel

%% Cuerpo de la funcion

%efectuo interpolación para ganar definición de los bordes
[m n]= size(I);
[x,y] = meshgrid(1:n, 1:m);
r=0.2;
[p,q]=meshgrid(1:r:n, 1:r:m);
I=double(I);
I2=interp2(x,y,I,p,q,'bilinear');%interpolacion bilineal


[X, ~, ~]=conjunto_de_nivel(I2); %conjuntos de nivel de I2

%Calculo las lineas de nivel 
[m,n]=size(X(1).data);
L = zeros(m-2,n-2);%inicializo la imagen de salida
%Laux2=L;
for j=Li+paso:paso:Lf%hacer desde el nivel de gris Li hasta el nivel de gris (Lf-paso) 
    lambda=X(j).lambda;%nivel de gris
    Laux=(X(j-paso).data - X(j).data);%esta resta está al reves pues los pixeles blancos se mapean como UNO y los negros como CERO
    %Laux2(:)=circshift(Laux', 1)';
    Lh = Laux(2:end-1,1:end-2);
    Lv = Laux(1:end-2,2:end-1);
    Ld1 = Laux(1:end-2, 1:end-2);
    Ld2 = Laux(3:end, 1:end-2);
    Laux = Laux(2:end-1, 2:end-1 );
    Laux=abs(Laux*4-Lh-Lv-Ld1-Ld2)*256;%lambda;
    %Laux=(abs(Laux-circshift(Laux2,1)))*lambda;%obtengo los bordes con nivel de gris lambda    
    L=L+(Laux);%agrego la linea de nivel a la imagen de salida
   
end

lambda=X(Li).lambda;%nivel de gris

Laux=(X(Li).data - X(Li+paso).data);%esta resta está al reves pues los pixeles blancos se mapean como UNO y los negros como CERO
Lh = Laux(2:end-1,1:end-2);
Lv = Laux(1:end-2,2:end-1);
Ld1 = Laux(1:end-2, 1:end-2);
Ld2 = Laux(3:end, 1:end-2);
Laux = Laux(2:end-1, 2:end-1 );
Laux=abs(Laux*4-Lh-Lv-Ld1-Ld2)*lambda;
%Laux=(abs(Laux-circshift(Laux2,1)))*lambda;%obtengo los bordes con nivel de gris lambda    
L=L+(Laux);%agrego la linea de nivel a la imagen de salida

lambda=X(Lf).lambda;%nivel de gris
Laux=(X(Lf-paso).data - X(Lf).data);%esta resta está al reves pues los pixeles blancos se mapean como UNO y los negros como CERO
Lh = Laux(2:end-1,1:end-2);
Lv = Laux(1:end-2,2:end-1);
Ld1 = Laux(1:end-2, 1:end-2);
Ld2 = Laux(3:end, 1:end-2);
Laux = Laux(2:end-1, 2:end-1 );
Laux=abs(Laux*4-Lh-Lv-Ld1-Ld2)*lambda;
%Laux=(abs(Laux-circshift(Laux2,1)))*lambda;%obtengo los bordes con nivel de gris lambda    
L=L+(Laux);%agrego la linea de nivel a la imagen de salida


%L=256-L;%grafo en negro y el fondo en blanco
%figure
%imagesc(L)
%figure
%imshow(mat2gray(L))
