function [NMF] = algo_nmfUnsupervisedEXP(H,W,V,iteration,setting)

sparsity = 0;
beta = setting.beta;
Vap = W*H;

if ~isequal(beta,0) || ~isequal(beta,1) || ~isequal(beta,2)
    if beta < 1
        gamma = 1/(2-beta);
    elseif beta >= 1 && beta <= 2
        gamma = 1;
    else
        gamma = 1/(beta-1);
    end
end

cost = zeros(1,iteration);
switch beta
    case 2
        for iter = 1:iteration
            
            W = W.*(V*H')./(Vap*H');
            W(isnan(W)) = 0;
            W = W./repmat(sum(W),size(W,1),1);
            Vap = W*H;

            H = H.*(W'*V)./(W'*Vap);
            H(isnan(H)) = 0;

            Vap = W*H;
            cost(iter) = betadivSUPSEMEXP(V,Vap,beta);
        end
    case 1
        for iter = 1:iteration
            W = W .* ((V./Vap)*H')./repmat(sum(H,2)',size(V,1),1);
            W(isnan(W)) = 0;
            W = W./repmat(sum(W),size(W,1),1);
            Vap = W*H;

            H = H.*((W'*(V./Vap))./(sparsity+W'*Vap.^(0)));
            H(isnan(H)) = 0;
            
            Vap = W*H;
            cost(iter) = betadivSUPSEMEXP(V,Vap,beta);
        end
    case 0
        for iter = 1:iteration
            
            W = W .* (((V.*Vap.^(-2))*H')./(Vap.^(-1)*H')).^gamma;
            W = W./repmat(sum(W),size(W,1),1);
            Vap = W*H;
            
            H = H.*((W'*(V.*Vap.^(-2)))./(sparsity+W'*Vap.^(-1))).^(1/2);
            
            Vap = W*H;
            cost(iter) = betadivSUPSEMEXP(V,Vap,beta);
        end
    otherwise
        if beta < 1
            for iter = 1:iteration
                if smoothness==0
                    H = H.*((W'*(V.*Vap.^(beta-2)))./(sparsity+W'*Vap.^(beta-1))).^(gamma);
                else
                    H = updateSmoothEssid(H,W,V,Vap,beta,smoothnessTot,sparsity,lambda);
                    H(isnan(H)) = 0;
                end
                
                Vap = W*H;
                cost(iter) = betadivSUPSEMEXP(V,Vap,setting.beta);
            end
        else
            for iter = 1:iteration
                
                if smoothness==0
                    H = H.*((W'*(V.*Vap.^(beta-2))-sparsity)./(W'*Vap.^(beta-1))).^(gamma);
                    H(H<0)=0;
                else
                    H = updateSmoothEssid(H,W,V,Vap,beta,smoothness,sparsity,lambda);
                    H(isnan(H)) = 0;
                end
                
                Vap = W*H;
                cost(iter) = betadivSUPSEMEXP(V,Vap,setting.beta);
            end
        end
end

NMF.Vap = Vap;
NMF.H = H;
NMF.W = W;
NMF.cost = cost;