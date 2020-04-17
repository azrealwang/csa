clear all;
close all;
load('data/lfw/LFW_10Samples_insightface.mat')
load('data/lfw/LFW_label_10Samples_insightface.mat')
labels=ceil(0.1:0.1:158);

addpath('matlab_tools');
addpath_recurse("btp")
    
opts.lambda = 0.5;% 0.5 1 2
opts.beta = 1;% 0.5 0.8 1
opts.K = 16;
opts.L = 512;
opts.gaussian=1; %1/0=gaussian/laplace
opts.dX=size(LFW_10Samples_insightface,2);
opts.model = random_IoM(opts);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% facenet iom generate dataset
db_data.X=LFW_10Samples_insightface';
[all_code, ~] = IoM(db_data, opts, opts.model);
transformed_data=all_code.Hx';

reconstruct_x=zeros(158,512);

% reconstruct the first one
for i=1:158
    disp(['reconstructing ',num2str(i)])
    to_retrieve_hash=transformed_data((i-1)*10+1,:); % first of the template are used to reconstruct
    %rng default % For reproducibility
    f_fitness = @(x)fitness_iom(x,to_retrieve_hash,opts); % fitness function
    f_constr = @(x)constraintsofx_iom(x,to_retrieve_hash,opts); % constraint function
    
    reconstruct_x(i,:) = reconstruct(f_fitness,f_constr,opts);
end

save(['data/iomhashing_reconstruct.mat'],'reconstruct_x');