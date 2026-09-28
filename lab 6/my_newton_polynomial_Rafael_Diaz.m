function [D,P] = my_newton_polynomial_Rafael_Diaz(X,Y)
% MY_NEWTON_POLYNOMIAL_FIRSTNAME_LASTNAME  Tabla de diferencias divididas
% y polinomio interpolante de Newton.
%
%   [D,P] = my_newton_polynomial_firstname_lastname(X,Y)
%
%   Entradas:
%     X : vector de nodos, reales, finitos y distintos entre si.
%     Y : vector de valores de la funcion en los nodos (misma longitud que X).
%
%   Salidas:
%     D : tabla de diferencias divididas (n x n). La primera columna es Y.
%         Los coeficientes de Newton quedan en la diagonal D(i,i).
%         Se usa NaN por encima de la diagonal.
%     P : function handle. P(x) evalua el polinomio de Newton en x
%         (x puede ser escalar o vector).

% ---------- Validaciones ----------
X = X(:)'; % fila
Y = Y(:)'; % fila

if isempty(X) || isempty(Y)
    error('X e Y no pueden estar vacios.');
end
if length(X) ~= length(Y)
    error('X e Y deben tener la misma longitud.');
end
if ~isreal(X) || ~isreal(Y) || any(~isfinite(X)) || any(~isfinite(Y))
    error('X e Y deben ser reales y finitos.');
end
if length(unique(X)) ~= length(X)
    error('Los nodos en X deben ser distintos entre si.');
end

n = length(X);

% ---------- Tabla de diferencias divididas ----------
D = NaN(n,n);
D(:,1) = Y';

for j = 2:n
    for i = j:n
        D(i,j) = (D(i,j-1) - D(i-1,j-1)) / (X(i) - X(i-j+1));
    end
end

% Coeficientes de Newton: diagonal de D
coefs = diag(D)';

% ---------- Polinomio de Newton como function handle ----------
P = @(x) evaluar_newton(x, coefs, X);

end

function p = evaluar_newton(x, coefs, X)
% Evalua el polinomio de Newton usando el esquema tipo Horner:
% P(x) = c1 + (x-x1)*(c2 + (x-x2)*(c3 + ... ))
n = length(coefs);
p = coefs(n) * ones(size(x));
for k = n-1:-1:1
    p = coefs(k) + (x - X(k)) .* p;
end
end