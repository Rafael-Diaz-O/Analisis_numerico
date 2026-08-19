function [x1, x2] = ecuacion_cuadratica_rafael_diaz(a, b, c)

% 1. Calcular el discriminante
disc = b^2 - 4*a*c;

% 2. Caso especial: si b == 0, usamos la fórmula estándar simplificada
if b == 0
    x1 = sqrt(-c/a);
    x2 = -sqrt(-c/a);
    return;
end

% 3. Cálculo estable usando la variable auxiliar q
% Usamos sign(b) para asegurar que sumemos números con el mismo signo
if b >= 0
    q = -0.5 * (b + sqrt(disc));
else
    q = -0.5 * (b - sqrt(disc));
end

% 4. Obtención de las dos raíces
x1 = q / a;
x2 = c / q;
end