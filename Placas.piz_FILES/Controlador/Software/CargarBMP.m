function CargarBMP (ArchivoBmp,Num)

Matriz = imread(ArchivoBmp,'bmp');
Matriz2 = PrepararMatriz(255-Matriz);
CargarMatriz(Matriz2,Num);