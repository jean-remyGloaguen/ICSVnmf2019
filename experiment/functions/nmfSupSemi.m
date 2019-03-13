function [store,config] = nmfSupSemi(config,setting,data)

sceneSelect = setting.sceneSelect;
TIR = setting.TIR;
dataset = setting.dataset;
type = setting.type;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DICTIONARY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(type,'nmf') 
    dictionary.W = data.dictionary.W;
    dictionary.frequency = data.dictionary.frequency;
    dictionary.indTraffic = data.dictionary.indTraffic;
    dictionary.numberPerClass = size(dictionary.W,2);
else
    dictionary = data.dictionary;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% BASELINE GLOBALE ERROR + FILTRE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch dataset
    case 'ambience'
        sceneType = setting.aType;
        creationSceneDir = strcat(config.inputPath, dataset, filesep, sceneType, filesep);
        
    case 'grafic'
        sceneType = setting.gType;
        creationSceneDir = strcat(config.inputPath, dataset, filesep, sceneType, filesep);
        
    case 'cars'
        creationSceneDir = strcat(config.inputPath, dataset, filesep);
end

files = dir(strcat(creationSceneDir, filesep, '*.wav'));
globalName = cell(1,length(files)/2);
ind = 1;

for ii = 1:length(files)
    if strfind(files(ii).name,'traffic')
        globalName{ind} = files(ii).name(1:end-12);
        ind = ind+1;
    end
end

numberScene = length(globalName)-round(length(globalName)*sceneSelect/100);
levels = cell(numberScene,1);
XScale = cell(numberScene,1);

if isempty(config.sequentialData)
    sequentialData = cell(numberScene,1);
else
    sequentialData = config.sequentialData;
end

for ii = 1:numberScene
    
    fileTraffic = audioread([creationSceneDir globalName{ii} '_traffic.wav']);
    fileRest = audioread([creationSceneDir globalName{ii} '_interfering.wav']);
    
    if strcmp(dataset,'ambience')
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
    
    [Vtraffic] = audio2SpectrogramEXP(fileTraffic',setting);
    [Lp,Leq] = estimationLpEXP(Vtraffic,setting);
    levels{ii}.LpTraffic =  Lp{1};
    levels{ii}.LeqTraffic = Leq(1);
    
    [V,Vlinear,~,~,XScale{ii}] = audio2SpectrogramEXP(fileTot',setting);
    [Lp,Leq] = estimationLpEXP(Vlinear,setting);
    levels{ii}.LpGlobal = Lp{1};
    levels{ii}.LeqGlobal = Leq(1);
    
    switch type
        case 'filter'
            [LeqFiltre,LpFiltre] = filtrePasseBasEXP(Vlinear,setting);
            levels{ii}.LeqTrafficEstimate = LeqFiltre;
            levels{ii}.LpTrafficEstimate = LpFiltre;
            sequentialData{ii} = 0;
            levels{ii}.cost = 0;
            
        case 'nmf'
            [LeqTrafficEstimate,LpTrafficEstimate,H,cost,sequentialData{ii},time] =...
                NMFestimationEXP(V,dictionary,setting,sequentialData{ii});
            
            levels{ii}.LeqTrafficEstimate = LeqTrafficEstimate;
            levels{ii}.LpTrafficEstimate = LpTrafficEstimate;
            levels{ii}.time = time;
            
            levels{ii}.cost = cost;
            
    end
end

config.sequentialData = sequentialData;
store.levels = levels;