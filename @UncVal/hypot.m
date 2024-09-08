function C = hypot(A, B)
%HYPOT hypot function for UncVal objects
% overflow/underflow protection not implemented for UncVal objects
% but implementing the naive version of this function will let us use the
% default cart2pol

C = sqrt(A.^2 + B.^2);
end

