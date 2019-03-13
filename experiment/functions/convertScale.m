function [X,frequency] = convertScale(X,setting)

frequency = linspace(0,setting.sr/2,setting.nfft/2+1);

switch setting.domain
    case 'spectra'
        frequency = linspace(0,setting.sr/2,setting.nfft/2);
        [~,ind] = min(abs(frequency-setting.fc));
        X = X(1:ind,:);
    case 'thirdOctave'
        [X,frequency] = NarrowToNthOctave(frequency,X,3);
    case 'mel bands'
        [X,frequency] = spectre2Mel(X,setting.numberMel,setting.sr);
        
end