%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Build up new table after HSPICE runs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NewSampleNum=length(ID_SVM);
outputs_new=[];
spice_data=textread('path_new.txt'); % output file of hspice
for n=1:NewSampleNum
    outputs_new=[outputs_new spice_data(121*n,1)]; 
    % outputs delays are at the 121*(1,2,3...) rows in the mt0 file
end
outputs_new=outputs_new';
%{
sweep_data=textread('sweep_data_mc.txt');
sweep_data(:,7)=[];
samples_new=reshape(sweep_data',[360,NewSampleNum])';
%}