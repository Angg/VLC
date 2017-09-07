% Parameter definition
Nfft = 64;
Ncp = Nfft/4;

% Shapiro-Rudin Sequence [1 1 1 -1] with Hermitian Symmetry to generate DMT
% signal
ShapRudin64Seq = [[0 1 1 1 -1 1 1 1 -1 1 1 1 -1 1 1 1 -1 1 1 1 -1 1 1 1 -1 1 1 1 -1 0 0 0], 
                 [0 0 0 0 -1 1 1 1 -1 1 1 1 -1 1 1 1 -1 1 1 1 -1 1 1 1 -1 1 1 1 -1 1 1 1]];
ShapRudin64Seq = [ShapRudin64Seq(1,:) ShapRudin64Seq(2,:)];
% Shapiro-Rudin symbol for timing synchronization
ShapRudin64TimeSynchSym = ifft(ShapRudin64Seq,Nfft);
% Add cyclic prefix
ShapRudin64TimeSynchSym = [ShapRudin64TimeSynchSym(Nfft-Ncp+1:Nfft) ShapRudin64TimeSynchSym];
% Repeat into 2 consecutive symbol
ShapRudin64TimeSynchSym = [ShapRudin64TimeSynchSym ShapRudin64TimeSynchSym];
% Transmitted symbol
RandData1 = rand(1,64)-1/2; RandData2 = rand(1,64)-1/2; RandData3 = rand(1,64)-1/2;
RandData = [RandData1(Nfft-Ncp+1:Nfft) RandData1 RandData2(Nfft-Ncp+1:Nfft) RandData2 RandData3(Nfft-Ncp+1:Nfft) RandData3];
TxSym = [zeros(1,32) ShapRudin64TimeSynchSym RandData];
%TxSym = awgn(TxSym,25);
TxSymLen = length(TxSym);

% Modified Park Timing Estimation Method
i=1;P=zeros(1,TxSymLen-(2*Nfft+Ncp)+1);R=zeros(1,TxSymLen-(2*Nfft+Ncp)+1);
for d = (1+Nfft+Ncp:TxSymLen-Nfft)
    for k = (1:Nfft)
        P(i) = P(i) + TxSym(d-k-Ncp)*TxSym(d+k); 
    end
    P(i) = TxSym(d)^2 + P(i);
    for k = (0:Nfft)
        R(i) = R(i) + abs(TxSym(d+k))*abs(TxSym(d+k));
    end
    M(i) = abs(P(i))^2 / R(i)^2;
    i=i+1;
end
% Plot the timing metric
% Highest magnitude in the metric shows the start position of the first
% timing sequence symbol after it's cyclic prefix
plot(TxSym);figure;plot(M);