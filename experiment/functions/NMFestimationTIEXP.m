function [NMF,sequentialData] = NMFestimationTIEXP(V,dictionary,setting,sequentialData)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% limit the spectrogram and the dictionary to cutOffFreq %%%%%%%%%%%%%%%%%
[soundMix] = cutSpectrogramTIEXP(dictionary.W,setting);
soundMix.indTraffic = dictionary.indTraffic;

W0 = soundMix.W(1:soundMix.ind,:);      % initial dictionary
V = V(1:soundMix.ind,:);    % spectrogram to approximate

if isempty(sequentialData)
    iteration = setting.iteration;

    W = W0;                             % first iteration W = W0
%     W = rand(size(W0,1),size(W0,2));
    binTemp = size(V,2);
    rng(soundMix.seed)
    H = rand(size(W,2),binTemp);    % H initiate randomly
else
    % continuing step of the sequential run
    iteration = setting.iteration-sequentialData.numberIteration;
    H = sequentialData.H;
    W = sequentialData.W; 
end

NMF = algo_nmfUnsupervisedEXP(H,W,V,iteration,setting);


sequentialData.numberIteration = setting.iteration;
sequentialData.H = NMF.H;
sequentialData.W = NMF.W;




