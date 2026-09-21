%1.a
function T = my_taylor_Rafael_Diaz(x0, D, n, x)
% MY_TAYLOR_FIRSTNAME_LASTNAME  Evaluates the n-th order Taylor polynomial
% of a function f, centered at x0, using precomputed derivative values.
%
%   T = my_taylor_firstname_lastname(x0, D, n, x)
%
%   Inputs:
%       x0 - center of the expansion (scalar)
%       D  - vector of derivative values at x0:
%            D = [f(x0), f'(x0), f''(x0), ..., f^(n)(x0)]
%            (length n+1)
%       n  - degree of the Taylor polynomial (nonnegative integer)
%       x  - vector (or scalar) of evaluation points
%
%   Output:
%       T  - values of the Taylor polynomial T_n evaluated at x
%
%   Formula:
%       T_n(x) = sum_{k=0}^{n} [ f^(k)(x0) / k! ] * (x - x0)^k

% Basic input check: D must contain n+1 derivative values
if numel(D) < n + 1
    error('D must contain at least n+1 values: f(x0), f''(x0), ..., f^(n)(x0).');
end

T = zeros(size(x));            % initialize output, same shape as x

for k = 0:n
    term = (D(k+1) / factorial(k)) .* (x - x0).^k;
    T = T + term;
end

end