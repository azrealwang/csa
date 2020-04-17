% let see if we take 100
clear all;
close all;

addpath('matlab_tools');
addpath_recurse("btp")

load('data/lfw/LFW_10Samples_insightface.mat')
load('data/lfw/LFW_label_10Samples_insightface.mat')

labels=ceil(0.01:0.1:158);

% this is another application systen and new key for the system

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


scores = 1- pdist2(transformed_data,transformed_data,'Hamming');
tmp_logic = diag(labels'==labels);
gen_logic = labels'==labels-diag(tmp_logic);
hamming_gen_score = scores(gen_logic);
hamming_imp_score = scores(labels'~=labels);
[EER_HASH_orig, mTSR, mFAR, mFRR, mGAR,threshold] =computeperformance(hamming_gen_score, hamming_imp_score, 0.001);  % isnightface 3.43 % 4.40 %
[FAR_orig,FRR_orig] = FARatThreshold(hamming_gen_score,hamming_imp_score,threshold);

attack_label=1:158;
%% With constraint
load(['data/iomhashing_reconstruct.mat'],'');
% facenet iom generate dataset
db_data.X=reconstruct_x';
[all_code, ~] = IoM(db_data, opts, opts.model);
attacker_transformed_data=all_code.Hx';

approxmate_scores = 1- pdist2(attacker_transformed_data,transformed_data,'Hamming');
approxmate_gen_score = approxmate_scores(attack_label'==labels);
approxmate_imp_score = approxmate_scores(attack_label'~=labels);
[EER_HASH_attack, mTSR, mFAR, mFRR, mGAR] =computeperformance(hamming_gen_score, approxmate_gen_score, 0.001); 
[FAR_attack,FRR_attack] = FARatThreshold(hamming_gen_score,approxmate_gen_score,threshold);

str_head=['EER,FAR,FAR_attack\r\n'];
str_log=[num2str(EER_HASH_orig),',',num2str(FAR_orig*100),',',num2str(FAR_attack*100),'\r\n'];
disp(str_log);
fid=fopen('logs/isa.csv','a');
fprintf(fid,str_head);
fprintf(fid,str_log);
fclose(fid);