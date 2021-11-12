#Trabajo Practico N2
#Balances de masa metabolicos en la ingenieria biomedica

disp("PUNTO A")
#PUNTO A) Metodo de eliminacion gaussiana con el metodo directo

#Creamos la matriz ampliada
RQ = 0.2;
A = [ RQ 0 1 1 0 ; 1 3 -1 -1 -1 ;-1 -1 20 0 2 ;-1 -1 0 8 4 ; 0 0 2 0 7 ];
b = [ 2 ; -6 ; 1 ; 0 ; 5];
matrizAmpliada = [ RQ 0 1 1 0 2; 1 3 -1 -1 -1 -6;-1 -1 20 0 2 1;-1 -1 0 8 4 0; 0 0 2 0 7 5]

#Triangulomatriz
function matrizTriangulada = triangularMatriz(A)
 [n,l]=size(A);
 for k= 1:n-1
   for i = k+1:n
     m=A(i,k)/A(k,k);
     for j=k:l
       A(i,j)=A(i,j)- m*A(k,j);
     endfor
   endfor
 endfor
 matrizTriangulada = A
endfunction

matrizAmpliadaTriangulada = triangularMatriz(matrizAmpliada);

#Sustitución inversa

function resultado = sustitucionInversa(A)
  [n,l]=size(A);
  x=zeros(l-1,1);
  for i= n:-1:1
   cont=0;
   for j=i+1: n 
     cont= cont + A(i,j)*x(j);
   endfor
   x(i)=(A(i,6)-cont)/A(i,i);
  endfor
  resultado = x;
endfunction

disp("Por sustitucion inversa despejo las variables")

resultadoGauss = sustitucionInversa(matrizAmpliadaTriangulada)

disp("PUNTO B")
#Punto B) Resuelve sistema de ecuaciones por Jabobi y Gauss-seidel

#Método de Jacobi
disp("Metodo de Jacobi")
tolerancia = 0.0001;
function resultadoJacobi = metodoDeJacobi(A,b,tolerancia)
 [n,l]=size(A);
 semilla = zeros(1,n);
 X = semilla;
 cont = 0;
 norma = 1;
 matrizJacobi = zeros(1,n+2);
 while norma > tolerancia
  cont = cont + 1;
  matrizJacobi(cont,1) = cont;
   for i = 1 : n
    suma = 0;
    for j = 1 : n
      if i ~= j
       suma = suma + A(i,j)* semilla(j);
      endif
    endfor 
    X(i) = (b(i) - suma) / A(i,i);
    matrizJacobi(cont,i+1) = X(i); 
   endfor
  norma = norm(semilla - X);
  matrizJacobi(cont,n+2) = norma; 
  semilla = X ;
 endwhile
 resultadoJacobi = matrizJacobi;
endfunction

matrizMetodoJacobi = metodoDeJacobi(A,b,tolerancia)

xjacobi=[matrizMetodoJacobi(153,2); matrizMetodoJacobi(153,3); matrizMetodoJacobi(153,4); matrizMetodoJacobi(153,5); matrizMetodoJacobi(153,6)] 

#Método de Gauss-Seidel
disp("Metodo de Gauss-Seidel")

function resultadoGaussSeidel = metodoDeGaussSeidel(A,b,tolerancia)
 [n,l]=size(A);
 semilla = zeros(1,n);
 X = semilla;
 cont = 0;
 norma = 1;
 matrizGaussSeidel = zeros(1,n+2);
 while norma > tolerancia
  cont = cont + 1;
  matrizGaussSeidel(cont,1) = cont;
   for i = 1 : n
    suma = 0;
    for j = 1 : n
      if i ~= j
       suma = suma + A(i,j)* X(j);
      endif
    endfor 
    X(i) = (b(i) - suma) / A(i,i);
    matrizGaussSeidel(cont,i+1) = X(i); 
   endfor
  norma = norm(semilla - X);
  matrizGaussSeidel(cont,n+2) = norma; 
  semilla = X ;
 endwhile
 resultadoGaussSeidel = matrizGaussSeidel;
endfunction

matrizMetodoGaussSeidel = metodoDeGaussSeidel(A,b,tolerancia)

xgaussseidel=[matrizMetodoGaussSeidel(18,2);matrizMetodoGaussSeidel(18,3);matrizMetodoGaussSeidel(18,4);matrizMetodoGaussSeidel(18,5);matrizMetodoGaussSeidel(18,6)]
disp("PUNTO C")
#Punto c) Resuelve sistema de ecuaciones por metodo de Sobrerrelajaciones sucesivas (SOR)

function resultadoSOR = metodoDeSOR(A,b,tolerancia,w)
 [n,l]=size(A);
 semilla = zeros(1,n);
 X = semilla;
 cont = 0;
 norma = 1;
 matrizSOR = zeros(1,n+2);
 while norma > tolerancia
  cont = cont + 1;
  matrizSOR(cont,1) = cont;
   for i = 1 : n
    suma = 0;
    for j = 1 : n
      if i ~= j
       suma = suma + A(i,j) * X(j);
      endif
    endfor   
    gs = (b(i) - suma) / A(i,i);
    X(i) = w * gs + (1 - w) * semilla(i);
    matrizSOR(cont,i+1) = X(i); 
   endfor
  norma = norm(semilla - X);
  matrizSOR(cont,n+2) = norma; 
  semilla = X ;
 endwhile
 resultadoSOR = matrizSOR;
    
endfunction

w = 0.9;
matrizMetodoSOR = metodoDeSOR(A,b,tolerancia,w)

w = 0.85;
matrizMetodoSOR = metodoDeSOR(A,b,tolerancia,w)

w = 1.3;
matrizMetodoSOR = metodoDeSOR(A,b,tolerancia,w)

w = 1.17;
matrizMetodoSOR = metodoDeSOR(A,b,tolerancia,w)

w = 1.25;
matrizMetodoSOR = metodoDeSOR(A,b,tolerancia,w)

xsor=[matrizMetodoSOR(9,2);matrizMetodoSOR(9,3);matrizMetodoSOR(9,4);matrizMetodoSOR(9,5);matrizMetodoSOR(9,6)]

disp("PUNTO D")
#Calcula error de aproximaciones por los diferentes metodos usando la norma vectorial infinita
x1=resultadoGauss
disp(xjacobi)
#Comparacion Jacobi con eliminacion gaussiana

r1=xjacobi-x1
normr1=norm(r1,inf)

#Comparacion Gauss-Seidel con eliminación gaussiana
r2=xgaussseidel-x1
normr2=norm(r2,inf)

#Comparacion SOR con eliminacion gaussiana
r3=xsor-x1
normr3=norm(r3,inf)

disp("PUNTO E")
#Realizar analisis de sensibilidad de la variable RQ  

w = 1.25;
RQ=0.3
A = [ RQ 0 1 1 0 ; 1 3 -1 -1 -1 ;-1 -1 20 0 2 ;-1 -1 0 8 4 ; 0 0 2 0 7 ];
b = [ 2 ; -6 ; 1 ; 0 ; 5];
matrizMetodoSOR = metodoDeSOR(A,b,tolerancia,w)

RQ=0.4
A = [ RQ 0 1 1 0 ; 1 3 -1 -1 -1 ;-1 -1 20 0 2 ;-1 -1 0 8 4 ; 0 0 2 0 7 ];
b = [ 2 ; -6 ; 1 ; 0 ; 5];
matrizMetodoSOR = metodoDeSOR(A,b,tolerancia,w)

RQ=0.5
A = [ RQ 0 1 1 0 ; 1 3 -1 -1 -1 ;-1 -1 20 0 2 ;-1 -1 0 8 4 ; 0 0 2 0 7 ];
b = [ 2 ; -6 ; 1 ; 0 ; 5];
matrizMetodoSOR = metodoDeSOR(A,b,tolerancia,w)

RQ=0.6
A = [ RQ 0 1 1 0 ; 1 3 -1 -1 -1 ;-1 -1 20 0 2 ;-1 -1 0 8 4 ; 0 0 2 0 7 ];
b = [ 2 ; -6 ; 1 ; 0 ; 5];
matrizMetodoSOR = metodoDeSOR(A,b,tolerancia,w)

#PUNTO F
disp("PUNTO F")
 #Calcula la diferencia metodo Jacobi:
 
RQ = 0.2;
A = [ RQ 0 1 1 0 ; 1 3 -1 -1 -1 ;-1 -1 20 0 2 ;-1 -1 0 8 4 ; 0 0 2 0 7 ];
b = [ 2 ; -6 ; 1 ; 0 ; 5];
tolerancia = 0.0001;
function resultadoJacobi = ConvergenciaJacobi(A,b,tolerancia)
 Gauss2=[8.33661 -4.44685 0.17815 0.15453 0.66339]
 [n,l]=size(A);
 semilla = zeros(1,n);
 X = semilla;
 cont = 0;
 norma = 1;
 matrizJacobi = zeros(1,n+2);
 MatrizDiferencia=zeros(n)
 while norma > tolerancia
  cont = cont + 1;
  matrizJacobi(cont,1) = cont;
   for i = 1 : n
    suma = 0;
    for j = 1 : n
      if i ~= j
       suma = suma + A(i,j)* semilla(j);
      endif
    endfor 
    X(i) = (b(i) - suma) / A(i,i);
    matrizJacobi(cont,i+1) = X(i); 
   endfor
  norma = norm(semilla - X);
  norma1 = norm(X - Gauss2);
  matrizJacobi(cont,n+2) = norma;
  matrizJacobi(cont,n+3) =norma1;
  semilla = X ;
 endwhile
 resultadoJacobi = matrizJacobi;
endfunction
matrizMetodoJacobi = ConvergenciaJacobi(A,b,tolerancia)
#Calcula la diferencia metodo Gauss-Seidel:
RQ = 0.2;
A = [ RQ 0 1 1 0 ; 1 3 -1 -1 -1 ;-1 -1 20 0 2 ;-1 -1 0 8 4 ; 0 0 2 0 7 ];
b = [ 2 ; -6 ; 1 ; 0 ; 5];
function resultadoGaussSeidel = CovergenciaGaussSeidel(A,b,tolerancia)
 Gauss2=[8.33661 -4.44685 0.17815 0.15453 0.66339];
 [n,l]=size(A);
 semilla = zeros(1,n);
 X = semilla;
 cont = 0;
 norma = 1;
 matrizGaussSeidel = zeros(1,n+2);
 while norma > tolerancia
  cont = cont + 1;
  matrizGaussSeidel(cont,1) = cont;
   for i = 1 : n
    suma = 0;
    for j = 1 : n
      if i ~= j
       suma = suma + A(i,j)* X(j);
      endif
    endfor 
    X(i) = (b(i) - suma) / A(i,i);
    matrizGaussSeidel(cont,i+1) = X(i); 
   endfor
  norma = norm(semilla - X);
  norma1 = norm(X - Gauss2);
  matrizGaussSeidel(cont,n+2) = norma; 
  matrizGaussSeidel(cont,n+3) =norma1;
  semilla = X ;
 endwhile
 resultadoGaussSeidel = matrizGaussSeidel;
endfunction

matrizMetodoGaussSeidel = CovergenciaGaussSeidel(A,b,tolerancia)

#Calcula la diferencia metodo SOR:
RQ = 0.2;
A = [ RQ 0 1 1 0 ; 1 3 -1 -1 -1 ;-1 -1 20 0 2 ;-1 -1 0 8 4 ; 0 0 2 0 7 ];
b = [ 2 ; -6 ; 1 ; 0 ; 5];
function resultadoSOR = ConvergenciaDeSOR(A,b,tolerancia,w)
 Gauss2=[8.33661 -4.44685 0.17815 0.15453 0.66339];
 [n,l]=size(A);
 semilla = zeros(1,n);
 X = semilla;
 cont = 0;
 norma = 1;
 matrizSOR = zeros(1,n+2);
 while norma > tolerancia
  cont = cont + 1;
  matrizSOR(cont,1) = cont;
   for i = 1 : n
    suma = 0;
    for j = 1 : n
      if i ~= j
       suma = suma + A(i,j) * X(j);
      endif
    endfor   
    gs = (b(i) - suma) / A(i,i);
    X(i) = w * gs + (1 - w) * semilla(i);
    matrizSOR(cont,i+1) = X(i); 
   endfor
  norma = norm(semilla - X);
  norma1 = norm(X - Gauss2);
  matrizSOR(cont,n+2) = norma;
  matrizSOR(cont,n+3) =norma1; 
  semilla = X;
 endwhile
 resultadoSOR = matrizSOR;
    
endfunction
w = 0.85;
matrizMetodoSOR = ConvergenciaDeSOR(A,b,tolerancia,w)

hold on

graficoGauss = plot(matrizMetodoGaussSeidel(:,1),matrizMetodoGaussSeidel(:,8))
graficoJacobi = plot(matrizMetodoJacobi(:,1),matrizMetodoJacobi(:,8))
graficoSOR = plot(matrizMetodoSOR(:,1),matrizMetodoSOR(:,8))

hold off






