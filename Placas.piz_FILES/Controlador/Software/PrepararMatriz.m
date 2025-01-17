function Salida = PrepararMatriz(Matriz)

[A B] = size(Matriz);

if ~(A==225 && B==300)
    disp('ERROR');
    Salida = 0;
    return;
end

Salida = uint8(zeros(240,328));

% Salida = 255*ones(240,328);
% for j = 2:2:328
%     Salida(:,j) = zeros(240,1);
% end

for i = 1:A
    for k = 1:B
        Salida(i+8,k+16)=Matriz(i,k);
    end
end

% Salida(6:7,11:322) = 255;
% Salida(235:236,11:322) = 255;
% Salida(6:236,11:14) = 255;
% Salida(6:236,319:322) = 255;

% La salida es de 240 x 328
Salida = uint8(Salida);
