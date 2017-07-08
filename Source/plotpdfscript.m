%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot PDF for High Sigma Region
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% For golden case, Prob(outputs>1.36e-10)=0.007158
Prob_t1=0.007158;

% High sigma region 3 sigma ~ 6 sigma ( 1.36e-10 ~ 1.40e-10 )

plotpdf(outputs,1e-14,1.36e-10,1.367e-10,1/500000)
plotpdf(outputs_5000,1e-14,1.368e-10,1.375e-10,Prob_t1/2488)
plotpdf(outputs_new,1e-14,1.376e-10,1.4e-10,0.5*Prob_t1/2488)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute Number of Samples in 3 Parts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P1=0;
P2=0;
P3=0;
for n=1:length(outputs)
    if (outputs(n)>=1.36e-10)&&(outputs(n)<1.367e-10)
        P1=P1+1;
    end
end

for n=1:length(outputs_5000)
    if (outputs_5000(n)>=1.367e-10)&&(outputs_5000(n)<1.375e-10)
        P2=P2+1;
    end
end

for n=1:length(outputs_new)
    if (outputs_new(n)>=1.375e-10)&&(outputs_new(n)<1.4e-10)
        P3=P3+1;
    end
end