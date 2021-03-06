%  Sample implementation of the Hafnian computation algorithm.
%  The matrix is assumed to have zero on the diagonal (these entries are not used) and being symmetric.
%  Author: Andreas Björklund
function [res]=hafnian(A)
n=size(A,1);
D=kron(eye(n/2),[0 1;1 0]);
A=A*D;
comb = zeros(2, n/2+1);
res = 0;
for X=1:2^(n/2)-1,
    sieve=double(dec2bin(X,n/2)=='1');
    D=kron(sieve, [1 1]);
    ix=find(D==1);
    B=A(ix,ix);
    E=eig(B); % O(n^3)
    % Compute combinations in O(n^2log n) time
    cnt = 1;
    comb(1,:) = zeros(1, n/2+1);
    comb(1, 1) = 1;
    for i=1:n/2,
        % Trace of A(ix,ix)^i/(2i)
        factor = sum(E.^i) / (2*i); 
        powfactor = 1;
        cnt = 3 - cnt;
        comb(cnt, :) = comb(3-cnt, :);
        for j=1:n/(2*i),
            powfactor = powfactor * factor / j;
            for k=i*j+1:n/2+1,
                comb(cnt, k) +=\
                comb(3-cnt, k-i*j) * powfactor;
            end
        end
    end
    if (mod(sum(sieve) - n/2, 2)) == 0,
        res += comb(cnt, n/2+1);
    else
        res -= comb(cnt, n/2+1);
    end
end