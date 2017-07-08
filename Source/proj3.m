%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Importance Sampling
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select samples near failure region
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

outputs_sel_shifted=[];
samples_sel_shifted=[];
threshold=1.36e-10;
limit=1.37e-10; % select overlapping region 1.36e-10~1.37e-10
numoverlap=0;
for n = 1:length(outputs)
    if outputs(n)>threshold
        outputs_sel_shifted=[outputs_sel_shifted outputs(n)];
        samples_sel_shifted=[samples_sel_shifted samples(n,:)'];  
        if outputs(n)<limit
            numoverlap=numoverlap+1;
        end
    end
end
outputs_sel_shifted=outputs_sel_shifted';
samples_sel_shifted=samples_sel_shifted';

mean_sel_shifted=[];
for n=1:360
    mean_sel_shifted=[mean_sel_shifted mean(samples_sel_shifted(:,n))];
end

var_sel_shifted=[];
for n=1:360
    var_sel_shifted=[var_sel_shifted var(samples(:,n))];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate MC data for mean shift
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
amount = 10000;
for k = 1:amount
    for i = 1:360
        samples_shifted(k,i) = normrnd(mean_sel_shifted(i),sqrt(var_sel_shifted(i)));
    end
end





%%%%%%%%%%%%%%%%%%%%%
%        SVM
%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SVM training on recoginizing failure region
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

samples_r=[];
for n=1:60
    samples_r =[samples_r samples(:,6*n-2)]; % Choose the 4th of every 6 variables
end
ID_nearFR = find(outputs >=1.365e-10);
samples_nearFR = samples_r(ID_nearFR,:);
[len,wid]=size(samples_nearFR);
label = zeros(1,len);
ID_FR = find(outputs(ID_nearFR) >=1.37e-10);
label(ID_FR) = 1;
svm = fitcsvm(samples_nearFR,label,'KernelFunction','polynomial','KernelScale','auto');

% Test

res = predict(svm, samples_nearFR);
sb = find(res==1);
sbb = intersect(sb,ID_FR);
rate=size(sbb)./size(sb);
display(rate(1));



%%%%%%%%%%%%%%%%
% SVM screening
%%%%%%%%%%%%%%%%

samples_shifted_r=[];
for n=1:60
    samples_shifted_r =[samples_shifted_r samples_shifted(:,6*n-2)];
end
res = predict(svm, samples_shifted_r);
ID_SVM = find(res==1);
%display(ID_SVM);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate MC data file for new spice run
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fid= fopen('sweep_data_mc.txt','wt');
for k = 1:length(ID_SVM)
    for i = 1:60
       for j = 1:6
           v = samples_shifted(ID_SVM(k),(i-1)*6+j);
           fprintf(fid, '%s\t', v);
       end
           fprintf(fid, '\n');
    end
end
fclose(fid);
