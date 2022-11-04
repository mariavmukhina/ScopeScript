function c = gcdInArray(A)
%GCDINARRAY will return gcd in array
% remove inf
A(A==inf) = [];
c = A(1);
for k = 2:length(A)
 c = gcd(c,A(k));
end

end

