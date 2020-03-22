function Matriz = VerImagen (NombreArchivo)
Matriz = uint8(zeros(240,328));
ArchivoImagen = fopen(NombreArchivo,'r');

if (ArchivoImagen < 0)
    disp('El archivo no existe');
else
    Vector = fread(ArchivoImagen,inf,'uint8');
    fclose(ArchivoImagen);

    [A B] = size(Vector);

    if (A~=240*328)
        disp('ERROR');
    else
        Matriz = uint8(zeros(240,328));

        for k = 1:240
            Matriz(k,:) = Vector( (k-1)*328+1 : (k-1)*328+328 );
        end

        VerMatriz(Matriz);
    end
end