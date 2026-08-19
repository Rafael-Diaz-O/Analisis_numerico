function [x1, x2] = ecuacion_cuadratica_rafael_diaz(a, b, c)

% 1. Calcular el discriminante
disc = b^2 - 4*a*c;

% 2. si b == 0, 
if b == 0
    x1 = sqrt(-c/a);
    x2 = -sqrt(-c/a);
    return;
end

% 3. Froma normal  
if b >= 0
    q = -(1/2) * (b + sqrt(disc));
else
    q = -(1/2) * (b - sqrt(disc));
end

% 4. raices 
x1 = q / a;
x2 = c / q;
end