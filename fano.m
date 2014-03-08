function f = fano(vals, varbias)
%fano(vals): Compute the fano factor for values in the vector 'vals'
%fano(vals, varbias), varbias=0/1 : Compute the fano factor for values in
%vector 'vals' with a unbiased estimator for the variance.
%
%if varbias==1 The variance is normalized by N – 1 (N > 1), where N is the sample size. 
%else the variance is computed with N

narginchk(1,2);
if ~exist('varbias', 'var') || isempty(varbias)
    varbias=0;
end

f = var(vals(:),varbias)/mean(vals(:));