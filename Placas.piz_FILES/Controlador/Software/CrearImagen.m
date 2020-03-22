function CrearImagen (NombreArchivo,Matriz)
% Crea un archivo binario cuyo nombre recibe como parametro en
% NombreArchivo. La matriz de entrada debe ser de 240 x 328

[A B] = size(Matriz);

if ~(A==240 && B==328)
    disp('ERROR');
else
    Vector = uint8(zeros(240*328,1));
    for k = 1:240
        Vector( (k-1)*328+1 : (k-1)*328+328 ) = Matriz(k,:);
    end    

    ArchivoImagen = fopen(NombreArchivo,'w+');
    fwrite(ArchivoImagen,Vector);
    fclose(ArchivoImagen);
end