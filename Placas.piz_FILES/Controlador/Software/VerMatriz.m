function VerMatriz(Matriz)
%  fun
%
%

[A B] = size(Matriz);

if ~(A==240 && B==328)
    disp('ERROR');
    return;
end

%%%%%%
%%% No deberia estar aca esta parte del codigo
Resolucion = 8;
Rango_Max = 2^Resolucion;
Rango = 1:(Rango_Max);

Mapa = zeros(Rango_Max, 3);
for i = Rango
    Mapa(i,:)= [ i i i ];
end
Mapa = (Mapa-1)/255;
colormap(Mapa);
%%%%%%
image(Matriz);