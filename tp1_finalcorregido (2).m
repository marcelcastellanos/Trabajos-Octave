#Punto A
matrizDemanda = load('DemandaSimple.dat');
matrizEnergias = load('EnergiasRenovablesSimple.dat');

#Machete de columnas de matriz demanda :P
anio = matrizDemanda(1,1);
mes = matrizDemanda(1,2);
demandaMes = matrizDemanda(1,3);

# Devuelve una matriz con 3 columnas Año-Mes-EnergiaTotalxMes
# Funcion auxiliar usada por la otra funcion que calcula el porcentaje
function energiaProducida = calculaEnergiaTotalxMes(matrizEnergia,matrizDemanda)
  matrizProducido = ones(length(matrizDemanda),3);
  matrizProducido(1,1) = matrizEnergia(1,1);
  matrizProducido(1,2) = matrizEnergia(1,2);
  suma = 0;
  cont = 1;
  
  for i = 1 : rows(matrizEnergia)
    anio = matrizEnergia(i,1);
    mes = matrizEnergia(i,2);
    matrizProducido(cont,3) = suma;
    if (matrizProducido(cont,1) == anio) && (matrizProducido(cont,2) == mes)
      suma = suma + matrizEnergia(i,6);
    elseif (matrizProducido(cont,2) != mes)
      matrizProducido(cont,3) = suma;
      cont = cont + 1;
      matrizProducido(cont,2) = mes;
      if (matrizProducido(cont,1) != anio)
          matrizProducido(cont,1) = anio;
      endif
      suma = 0;
    endif
   endfor
   
   energiaProducida = matrizProducido;
endfunction 

# Calcula el porcentaje de energia renovable sobre la demanda
# Devuelve una matriz con 5 columnas Año-Mes-Demanda-PorentajeCubierto-Sicumpleconley
# Si cumple con la ley (porcentaje mayor a 8) indica con 1 en la ultima columna
function porcentaje = porcentajeDemanda(matrizEnergia,matrizDemanda)
  matrizPorcentajes = ones(length(matrizDemanda),5);
  for i = 1 : 3
    matrizPorcentajes(:,i) = matrizDemanda(:,i);
  endfor
  
  energiaProducida = calculaEnergiaTotalxMes(matrizEnergia,matrizDemanda);
  
  for i = 1 : rows(matrizDemanda)
    demanda = matrizDemanda(i,3);
    producido = energiaProducida(i,3);
    porcentaje = (producido / demanda) * 100;
    matrizPorcentajes(i,4) = porcentaje;
    if (porcentaje >= 8)
      matrizPorcentajes(i,5) = 1;
    else
      matrizPorcentajes(i,5) = 0;
    endif
   endfor
  
  porcentaje = matrizPorcentajes;
  
  
endfunction

# Recibe el codigo de un tipo de energia 
# Calcula la cantidad de Energia de ese tipo generada por año en Gw-h
# Devuelve una matriz con columnas Año-Energia total generada 
function evolucionAnual = calcularEvolucionCodigo(matrizEnergia,codigo)
  matrizEvolucion = ones(10,2);
  matrizEvolucion(1,1) = matrizEnergia(1,1);
  suma = 0;
  cont = 1;
  
  for i = 1 : rows(matrizEnergia)
    anio = matrizEnergia(i,1);
    matrizEvolucion(cont,2) = suma;
    if (matrizEvolucion(cont,1) != anio)
      cont++;
      matrizEvolucion(cont,1) = anio;
      suma = 0;
    endif
      
    if (matrizEnergia(i,4) == codigo)
      suma = suma + matrizEnergia(i,6);
    endif
  endfor
   
   evolucionAnual = matrizEvolucion;
endfunction 

#Funcion para graficar
function grafico = graficayGuarda(ejeX,ejeY,titulo,nombreX,nombreY)
  graf = bar(ejeX,ejeY);
  xlabel(nombreX);
  ylabel(nombreY);
  title(titulo);
  grafico = graf;
endfunction
#Funcion para graficar
function grafico = graficayGuardaMismo(ejeX,ejeY,titulo,nombreX,nombreY)
  graf = plot(ejeX,ejeY);
  xlabel(nombreX);
  ylabel(nombreY);
  title(titulo);
  grafico = graf;
endfunction
#Recibe el codigo de una region, calcula el aporte por cada tipo de fuente 
# 1-Biodiesel , 2-Biogas ,3-Biomasa , 4-Eolica , 5-Hidraulica , 6-Solar
function aportes = calcularAportesRegion(matrizEnergia,codigoRegion)
  energias = [ 1 0 ; 2 0 ; 3 0 ; 4 0 ; 5 0 ; 6 0 ];
  for i = 1 : rows(matrizEnergia)
    if (matrizEnergia(i,5) == codigoRegion)
      codigoEnergia = matrizEnergia(i,4);
      energias(codigoEnergia,2) = energias(codigoEnergia,2) + matrizEnergia(i,6);
    endif
  endfor
  aportes = energias;
endfunction

#PUNTO B

disp("Punto B:")
porcentajes = porcentajeDemanda(matrizEnergias,matrizDemanda)

#PUNTO C
disp("Punto C:")
hold on;

evolucionEolica = calcularEvolucionCodigo(matrizEnergias,4)
graficoEolico = graficayGuardaMismo(evolucionEolica(:,1),evolucionEolica(:,2),"Evolucion energia por año","Año","Energia producida (Gw-h)");


evolucionHidraulica = calcularEvolucionCodigo(matrizEnergias,5)
graficoHirdaulico = graficayGuardaMismo(evolucionHidraulica(:,1),evolucionHidraulica(:,2),"Evolucion energia por año","Año","Energia producida (Gw-h)");

hold off;

#Punto D
disp("Punto D:")

aporteCuyo = calcularAportesRegion(matrizEnergias,104)
graficoCuyo = graficayGuarda(aporteCuyo(:,1),aporteCuyo(:,2),"Aporte Energetico del Cuyo en todo el periodo","Codigo de Energia","Energia producida (Gw-h)");
print -djpg aporte_cuyo.jpg;

aportePatagonia = calcularAportesRegion(matrizEnergias,108)
graficoPatagonia = graficayGuarda(aportePatagonia(:,1),aportePatagonia(:,2),"Aporte Energetico de la Patagonia en todo el periodo","Codigo de Energia","Energia producida (Gw-h)");
print -djpg aporte_patagonia.jpg;

aporteCentro = calcularAportesRegion(matrizEnergias,102)
graficoCentro = graficayGuarda(aporteCentro(:,1),aporteCentro(:,2),"Aporte Energetico del Centro en todo el periodo","Codigo de Energia","Energia producida (Gw-h)");
print -djpg aporte_centro.jpg;

#Punto E

matrizDemanda = load('DemandaSimple.dat');
matrizEnergia = load('EnergiasRenovablesSimple.dat');

#Crea matriz segun fuente para X anio
function aportes = calcularAportesAnio(matrizEnergia,anio)
energias = [ 1 0 ; 2 0 ; 3 0 ; 4 0 ; 5 0 ; 6 0 ];
  for i = 1 : rows(matrizEnergia)
    if (matrizEnergia(i,1) == anio)
      codigoEnergia = matrizEnergia(i,4);
      energias(codigoEnergia,2) = energias(codigoEnergia,2) + matrizEnergia(i,6);
    endif
  endfor
  aportes = energias;
 endfunction
 
 #Crea matriz de aportes segun region para X anio
 function aportes = calcularAportesAnioRegion(matrizEnergia,anio)
 energias = [ 101 0 ; 102 0 ; 103 0 ; 104 0 ; 105 0 ; 106 0 ; 107 0 ;108 0];
  for i = 1 : rows(matrizEnergia)
    if (matrizEnergia(i,1) == anio)
      codigoRegion = matrizEnergia(i,5);
      for j = 1:rows(energias)
        if (energias(j,1) == codigoRegion)
           energias(j,2) = energias(j,2) + codigoRegion;
           endif
      endfor
    endif
  endfor
  aportes = energias;
 endfunction
 
#PuntoE

disp("Punto E")
 
aporte2011fuente=calcularAportesAnio(matrizEnergia,2011);
aporte2019fuente=calcularAportesAnio(matrizEnergia,2019);

matrizdiferencia1= [ 1 0 ; 2 0 ; 3 0 ; 4 0 ; 5 0 ; 6 0 ];
for i = 1:rows(aporte2011fuente)
  diferencia1=aporte2019fuente(i,2)-aporte2011fuente(i,2);
  matrizdiferencia1(i,2)= diferencia1;
 endfor
 disp("Diferencia aporte entre 2011 y 2019 por fuente")
 
 disp(matrizdiferencia1)
 
 graficodiferenciafuente=bar(matrizdiferencia1(:,1),matrizdiferencia1(:,2))
 title("Diferencia aporte entre 2011 y 2019 por fuente")
 xlabel("Fuente")
 ylabel("Aporte")
 
aporte2011region=calcularAportesAnioRegion(matrizEnergia,2011);
aporte2019region=calcularAportesAnioRegion(matrizEnergia,2019);

matrizdiferencia2= [ 101 0 ; 102 0 ; 103 0 ;104 0 ; 105 0 ; 106 0 ; 107 0 ;108 0];

for i = 1:rows(aporte2011region)
  diferencia2=aporte2019region(i,2)-aporte2011region(i,2);
  matrizdiferencia2(i,2)= diferencia2 ;
 endfor
 disp("Diferencia aporte entre 2011 y 2019 por region")
 
 disp(matrizdiferencia2)
 
 graficodiferenciaregion=bar(matrizdiferencia2(:,1),matrizdiferencia2(:,2))
 title("Diferencia aporte entre 2011 y 2019 por region")
  xlabel("Region")
 ylabel("Aporte")
 
 
 #Punto F
disp("Punto F")


#Ordena la Matriz Energia
function ordenado=Ordenar(matrizEnergia)
fuente1=[];
for j=2011:2020
  for k=1:12
    for t=1:6
      for i=1:rows(matrizEnergia)
        if (matrizEnergia(i,1)==j && matrizEnergia(i,2)==k && matrizEnergia(i,4)==t)
           fuente1(end+1,:) = matrizEnergia(i,:);
        endif  
      endfor
    endfor
  endfor
endfor

ordenado=fuente1;

endfunction


#matrizordenada=Ordenar(matrizEnergia)      
    
#disp(matrizordenada)
  
#Matriz de porcentaje mensual de cada fuente en el periodo 2011-2020 
function porcentajemes=porcentajemes(matrizEnergia)
fuente1=[];
for j=2011:2020
  for k=1:12
    total=0;
    listacont=[];
    for t=1:6
      cont=0;
      for i=1:rows(matrizEnergia)
        if (matrizEnergia(i,1)==j && matrizEnergia(i,2)==k && matrizEnergia(i,4)==t)
           #fuente1(end+1,:) = matrizEnergia(i,:);
           cont=cont+matrizEnergia(i,6);
           total=total+matrizEnergia(i,6);
        endif  
      endfor
      listacont(end+1,1)=cont;
    endfor
    #disp(listacont)
    for s=1:6
      fuente1(end+1,:)=[j k s listacont(s,1)*100/total ];
    endfor
  endfor
endfor 

porcentajemes=fuente1;  
  
endfunction

disp("Matriz de porcentaje mensual de cada fuente en el periodo 2011-2020")
matrizporcentaje=porcentajemes(matrizEnergia)


function porcentajeanio=porcentajeanio(matrizEnergia)
fuente1=[];
for j=2011:2020
    total=0;
    listacont=[];
    for t=1:6
      cont=0;
      for i=1:rows(matrizEnergia)
        if (matrizEnergia(i,1)==j && matrizEnergia(i,4)==t)
           #fuente1(end+1,:) = matrizEnergia(i,:);
           cont=cont+matrizEnergia(i,6);
           total=total+matrizEnergia(i,6);
        endif  
      endfor
      listacont(end+1,1)=cont;
    endfor
    #disp(listacont)
    for s=1:6
      fuente1(end+1,:)=[j s listacont(s,1)*100/total ];
    endfor
  
endfor 

porcentajeanio=fuente1;  
  
endfunction

disp("Matriz de porcentajes por Fuente por Anio")
matrizanio=porcentajeanio(matrizEnergia)

#funcion que de la matriz de porcentaje te separa para cada fuente
function aporte=Porcentajefuente(matrizporcentaje,fuente1)
porcentajexfuente=[];
cont=1
  for i= 1:rows(matrizporcentaje)
    if (matrizporcentaje(i,3)==fuente1)
      porcentajexfuente(end+1,:)=[cont;matrizporcentaje(i,4)];
      cont=cont+1;
     endif
    
  endfor
  aporte=porcentajexfuente;
endfunction
 


aporteporcent1=Porcentajefuente(matrizporcentaje,1);
aporteporcent2=Porcentajefuente(matrizporcentaje,2);
aporteporcent3=Porcentajefuente(matrizporcentaje,3);
aporteporcent4=Porcentajefuente(matrizporcentaje,4);
aporteporcent5=Porcentajefuente(matrizporcentaje,5);
aporteporcent6=Porcentajefuente(matrizporcentaje,6);

disp(aporteporcent1)
disp(aporteporcent2)
disp(aporteporcent3)
disp(aporteporcent4)
disp(aporteporcent5)
disp(aporteporcent6)

#Grafica para cada fuente su porcentaje en el tiempo 


graficofuente1 = graficayGuardaMismo(aporteporcent1(:,1),aporteporcent1(:,2),"Porcentaje en el tiempo para cada fuente","tiempo","Porcenta Energia producida");
graficofuente2 = graficayGuardaMismo(aporteporcent2(:,1),aporteporcent2(:,2),"Porcentaje en el tiempo para cada fuente","tiempo","Porcenta Energia producida");
graficofuente3 = graficayGuardaMismo(aporteporcent3(:,1),aporteporcent3(:,2),"Porcentaje en el tiempo para cada fuente","tiempo","Porcenta Energia producida");
graficofuente4 = graficayGuardaMismo(aporteporcent4(:,1),aporteporcent4(:,2),"Porcentaje en el tiempo para cada fuente","tiempo","Porcenta Energia producida");
graficofuente5 = graficayGuardaMismo(aporteporcent5(:,1),aporteporcent5(:,2),"Porcentaje en el tiempo para cada fuente","tiempo","Porcenta Energia producida");
graficofuente6 = graficayGuardaMismo(aporteporcent6(:,1),aporteporcent6(:,2),"Porcentaje en el tiempo para cada fuente","tiempo","Porcenta Energia producida");

 
#PuntoG
#Detectar Central o Maquina con mas aporte durante el periodo

disp("Punto G")


matrizDemanda = load('DemandaSimple.dat');
matrizEnergia = load('EnergiasRenovablesSimple.dat');

function aporte=Mayoraporteporfuente(matrizEnergia,fuente)

cont=0;
 for i= 1:rows(matrizEnergia)
   if (matrizEnergia(i,4)==fuente)
     if (matrizEnergia(i,6)>cont)
       cont=matrizEnergia(i,6);
       maquina=matrizEnergia(i,3);
     endif
   endif
 endfor

 
energias = [ fuente maquina cont];
aporte= energias;
endfunction
     


aportes=zeros(6,3);

for i= 1 : 6
   aporte2=Mayoraporteporfuente(matrizEnergia,i);
   aportes(i,1)=aporte2(1,1);
   aportes(i,2)=aporte2(1,2);
   aportes(i,3)=aporte2(1,3);
endfor

disp("Tabla mayor aporte de maquina por fuente (fuente maquina aporte)")
disp(aportes)




