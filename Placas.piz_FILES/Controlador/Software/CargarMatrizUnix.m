function CargarMatriz(Matriz,Num)

[A B] = size(Matriz);

if ~(A==240 && B==328)
    disp('ERROR');
    return;
end

if (isfinite(Num)==0)|| (Num<0) || (Num>4)
    disp('ERROR');
    return;
end

Vector = uint8(zeros(1,240*328));
for k = 1:240
    Vector( ((k-1)*328+1) : ((k-1)*328+328) ) = Matriz(k,:);
end    

ArchivoImagen = fopen('ImagenTemporal.bin','w+');
fwrite(ArchivoImagen,Vector);
fclose(ArchivoImagen);
system(['./Linux/slmlao -CargarImagen ' num2str(Num) ' ImagenTemporal.bin']);
system('rm ImagenTemporal.bin');

