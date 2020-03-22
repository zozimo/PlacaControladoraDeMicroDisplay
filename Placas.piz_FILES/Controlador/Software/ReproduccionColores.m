

for k = 0:10:255
    k
    Matriz = uint8(k*ones(215,300));
    Matriz2 = PrepararMatriz(Matriz);
    CargarMatriz(Matriz2);
    pause(1);
end