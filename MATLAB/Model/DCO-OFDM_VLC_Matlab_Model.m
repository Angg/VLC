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