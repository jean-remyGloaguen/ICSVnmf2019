function [store,config] = nmfTI(config,setting,data)

TIR = setting.TIR;
dataset = setting.dataset;
type = setting.type;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DICTIONARY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(type,'nmf')
    dictionary.W = data.dictionary.W;
    dictionary.frequency = data.dictionary.frequency;
    dictionary.indTraffic = data.dictionary.indTraffic;
    nmf{1}.W0 = dictionary.W;
else
    dictionary = [];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% BASELINE GLOBALE ERROR + FILTRE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch dataset
    case 'ambience'
        creationSceneDir = strcat(config.inputPath, dataset, filesep, setting.aType, filesep);
        
    case 'grafic'
        creationSceneDir = strcat(config.inputPath, dataset, filesep, setting.gType, filesep);
        
    case 'cars'
        creationSceneDir = strcat(config.inputPath, dataset, filesep);
end

files = dir(strcat(creationSceneDir,filesep,'*.wav'));
globalName = cell(1,length(files)/2);
ind = 1;

for ii = 1:length(files)
    if ~isempty(strfind(files(ii).name,'traffic'))
        globalName{ind} = files(ii).name(1:end-12);
        ind = ind+1;
    end
end

numberScene = length(globalName)-round(length(globalName)*setting.sceneSelect/100);

nmf = cell(numberScene,1);

if strcmp(type,'nmf')
    nmf{1}.W0 = dictionary.W;
end

if isempty(config.sequentialData)
    sequentialData = cell(numberScene,1);
else
    sequentialData = config.sequentialData;
end
% LpRest{ii} = cell(numberScene,1);

for ii = 1:numberScene
    
    fileTraffic = audioread(strcat(creationSceneDir,globalName{ii},'_traffic.wav'));
    fileRest = audioread(strcat(creationSceneDir,globalName{ii},'_interfering.wav'));
    
    if strcmp(dataset,'ambience')        
        %% modif SNR
        A = rms(fileTraffic);
        B = rms(fileRest);
        if B ~= 0
            SNR_temp = 20*log10(A/B);
            facteur = 10.^((TIR-SNR_temp)/20);
            fileTraffic = facteur.*(fileTraffic);  % fichier perturbateur modifi�*
        end 
    end
    
    fileTraffic(fileTraffic == 0) = eps;
    fileTot = fileRest+fileTraffic;
    
%     [Vrest] = audio2SpectrogramEXP(fileRest',setting);
%     [LpRest{ii},~] = estimationLpEXP(Vrest,setting);    
    
    [Vtraffic] = audio2SpectrogramEXP(fileTraffic',setting);
    [Lp,Leq] = estimationLpEXP(Vtraffic,setting);
    nmf{ii}.LpTraffic =  Lp{1};
    nmf{ii}.LeqTraffic = Leq(1);
    
    [V,Vlinear] = audio2SpectrogramEXP(fileTot',setting);
    [Lp,Leq] = estimationLpEXP(V,setting);
    nmf{ii}.LpGlobal = Lp{1};
    nmf{ii}.LeqGlobal = Leq(1);
    
    [V,~] = convertScale(V,setting);
    
    switch type
        case 'filter'
            [LeqFiltre,LpFiltre] = filtrePasseBasEXP(Vlinear,setting);
            nmf{ii}.LeqTrafficEstimate = LeqFiltre;
            nmf{ii}.LpTrafficEstimate = LpFiltre;
            sequentialData{ii} = 0;
            nmf{ii}.cost = 0;
            nmf{ii}.indice = indiceEstimationEXP(fileTot);
            
        case 'nmf'
            [NMF,sequentialData{ii}] =...
                NMFestimationTIEXP(V,dictionary,setting,sequentialData{ii});
            
            indice = indiceEstimationEXP(fileTot);
            
            nmf{ii}.H = NMF.H;
            nmf{ii}.W = NMF.W;
            nmf{ii}.cost = NMF.cost(end);
            nmf{ii}.indice = indice;
    end 
end

config.sequentialData = sequentialData;
store.nmf = nmf;
