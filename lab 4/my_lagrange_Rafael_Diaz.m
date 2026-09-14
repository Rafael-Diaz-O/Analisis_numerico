function C = my_lagrange_Rafael_Diaz(X, Y)

%3 
% MY_LAGRANGE_FIRSTNAME_LASTNAME
% Construye el polinomio interpolador de Lagrange para puntos (X,Y)
% con valores de X distintos.
%
% C = my_lagrange_firstname_lastname(X,Y)
%
% Entradas:
%   X : vector de valores x (todos distintos)
%   Y : vector de valores y = f(x)
%
% Salida:
%   C : coeficientes del polinomio, de mayor a menor potencia,
%       listos para usarse con polyval(C,x)

X = X(:)';
Y = Y(:)';
n = length(X);

if length(Y) ~= n
    error('X y Y deben tener la misma longitud.');
end
if length(unique(X)) ~= n
    error('Los valores de X deben ser distintos.');
end

C = zeros(1, n); % polinomio de grado n-1 -> n coeficientes

for i = 1:n
    Li = 1;      % polinomio base L_i(x), representado como vector de coeficientes
    denom = 1;
    for j = 1:n
        if j ~= i
            Li = conv(Li, [1, -X(j)]); % multiplica por (x - X(j))
            denom = denom * (X(i) - X(j));
        end
    end
    C = C + (Y(i)/denom) * Li;
end

end