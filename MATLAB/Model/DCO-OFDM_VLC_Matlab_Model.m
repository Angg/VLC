%   DCO-OFDM Model for Visible Light Communication
%   Coder: Angga Pratama Putra
%
%   FFT point           : 64
%   Cyclic Extension    : 25% (16)
%   Active subcarrier   : 28
%   Modulation          : QPSK
%   Coding              : Convolutional/Viterbi
%   Single frame size   :
%       Time Synch      :
%       Data + CP       :
%   Burst               :
%   Total frame         :

% Clear workspace
close all
clear all
clc

%
% Parameter definition
%
Nfft = 64;
Ncp = Nfft/4;
Nact = 28; % Number of active subcarrier
Nburst = 10;
Nmod = 4; %QPSK modulation order
% Shapiro-Rudin Sequence [1 1 1 -1] with Hermitian Symmetry to generate DMT
ShapRudin64Seq = [[0 1 1 1 -1 1 1 1 -1 1 1 1 -1 1 1 1 -1 1 1 1 -1 1 1 1 -1 1 1 1 -1 0 0 0], 
                 [0 0 0 0 -1 1 1 1 -1 1 1 1 -1 1 1 1 -1 1 1 1 -1 1 1 1 -1 1 1 1 -1 1 1 1]];
ShapRudin64Seq = [ShapRudin64Seq(1,:) ShapRudin64Seq(2,:)];
% Shapiro-Rudin symbol for timing synchronization
ShapRudin64TimeSynchSym = ifft(ShapRudin64Seq,Nfft);
% Add cyclic prefix
ShapRudin64TimeSynchSym = [ShapRudin64TimeSynchSym(Nfft-Ncp+1:Nfft) ShapRudin64TimeSynchSym];
% Add spaces to differentiate the first 2 consecutive symbol as timing
% synch, and the next 2 consecutive spaces-timeSym to add averaging factor
% for channel estimation. The timing sync symbol also used for channel
% estimation. So the composition are 2 timingsync-channelest + spaces(1 ofdm 
% symbol) + channel est + spaces(1 ofdm symbol) + channel est.
% Channel estimation use 4 ofdm symbol to be averaged later.
% Notes:    If there are no spaces, there will be more than 1 peak
%           at timing metric calculation of time synchronizer. 
%           If there is only ShapRudin64TimeSynchSym without 
%           ShapRudin64ChannelEst at OFDMPreamb, channel estimation 
%           only averaged for 2 consecutive symbol.
%           Don't use zeros or values higher than ShapRudin symbol 
%           sequence peak as spaces! There will be lots of peak in timing
%           metric.
spaces = repmat(.1,1,80);
ShapRudin64ChannelEst = [spaces ShapRudin64TimeSynchSym];
ShapRudin64ChannelEst = [ShapRudin64ChannelEst ShapRudin64ChannelEst];
% Then the OFDM preamble are time sync. symbol + channel est.
ShapRudin64TimeSynchSym = [ShapRudin64TimeSynchSym ShapRudin64TimeSynchSym];
OFDMPreamb = [ShapRudin64TimeSynchSym ShapRudin64ChannelEst];


% Generate random binary data input
datain=randi([0 1],1,2800);

framedat = datain(1:28);
% Convolutional encoding
% Uses industry-standard generator polynomial g0=133, g1=171
% Code rate : 1/2
constr_len = 7;
gen_poly = [133 171];
trellis = poly2trellis(constr_len,gen_poly);
codeword = convenc(framedat,trellis);

% Data interleaving
% Uses block interleaver with (Nrow=8, Ncol=7)
intrlvd = matintrlv(codeword',8,7);

% Reshape binary data into decimal for QPSK modulation
% Interleaved data reshaped into matrix with Nrow=2. Ncol=28
mod_in_bin = reshape(intrlvd, 2, 28);
mod_in_dec = bi2de(mod_in_bin','right-msb');

% QPSK modulation
mod_data = qammod(mod_in_dec,Nmod);
%scatterplot(mod_data);

% IFFT
ifft_in = zeros(64,1);
ifft_in(2:29) = mod_data;
for i=(1:28)
    ifft_in(36+i)=ifft_in(30-i)'; % Hermitian symmetry
end
dmt_sig = ifft(ifft_in,Nfft);

% Add cyclic prefix
dmt_sig_cp = vertcat(dmt_sig(Nfft-Ncp+1:Nfft), dmt_sig);

% Transmitted signal + timing sequence
TxSym = vertcat(OFDMPreamb', dmt_sig_cp);

% Add symbol timing offset
timeOff = repmat(.05,1,32)';
TxSym_sto = vertcat(timeOff,TxSym);

% Add AWGN noise
% Loop with 5 dB interval to plot BER vs SNR
for SNRdB=(0:5:SNRdBmax)
    TxSym_sto_awgn = awgn(TxSym_sto,SNRdB,'measured');
    
    %
    % Time synchronizing
    %
    TxSymLen = length(TxSym_sto_awgn);
    % Modified Park Timing Estimation Method
    i=1;P=zeros(1,TxSymLen-(2*Nfft+Ncp)+1);R=zeros(1,TxSymLen-(2*Nfft+Ncp)+1);
    for d = (1+Nfft+Ncp:TxSymLen-Nfft)
        for k = (1:Nfft)
            P(i) = P(i) + TxSym_sto_awgn(d-k-Ncp)*TxSym_sto_awgn(d+k); 
        end
        P(i) = TxSym(d)^2 + P(i);
        for k = (0:Nfft)
            R(i) = R(i) + abs(TxSym_sto_awgn(d+k))*abs(TxSym_sto_awgn(d+k));
        end
        M(i) = abs(P(i))^2 / R(i)^2;
        i=i+1;
    end
    % Plot the timing metric
    % Highest magnitude in the metric shows the start position of the first
    % timing sequence symbol after its cyclic prefix
    %plot(TxSym_sto_awgn);figure;plot(M);
    % Get the maximum value of timing metric and its index
    [M_maxval, M_maxidx] = max(M);
    % Get the index of start position of data signal in the frame
    Preamb_len = length(OFDMPreamb);
    DataStartPos = M_maxidx + Preamb_len - Ncp;
    
    
    TxSym_sto_awgn_sim = vertcat(TxSym_sto_awgn, repmat(TxSym_sto_awgn(DataStartPos:TxSymLen),9,1));
    % Remove the cyclic prefix of each data burst
    % Stack each data symbol of data burst into the array column
    % Array size :  Nrow = Nfft,
    %               Ncol = Amount of data symbol in burst frame = Nburst
    DataSymbolArray = zeros(Nfft, Nburst);
    pos = DataStartPos;
    for c=(1:Nburst)
        pos = pos + Ncp;
        for r=(1:Nfft)
           DataSymbolArray(r,c) =  TxSym_sto_awgn_sim(pos+r-1);
        end
        if (c<Nburst)
            pos = pos+Nfft;
        end
    end
    
end
