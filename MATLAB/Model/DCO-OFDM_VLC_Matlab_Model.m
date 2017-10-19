%   DCO-OFDM Model for Visible Light Communication
%   Coder: Angga Pratama Putra
%
%   FFT point           : 64
%   Cyclic Extension    : 25% (16)
%   Active subcarrier   : 28
%   Modulation          : QPSK
%   Coding              : Convolutional/Viterbi
%   Single frame size   : 1280
%       TimeSynch + CE  : 480
%       Data + CP       : 80 * 10
%   Burst               : 10 data symbol
%   Total frame         : 10 frame for 1 simulation

% Clear workspace
close all
clear all
clc

%
% Parameter definition
%
SNRdBmax = 30;
Nfft = 64;
conv_coderate = 2;
Ncp = Nfft/4;
Nce = 4; % Number of channel estimation symbol
Nact = 28; % Number of active subcarrier
Nburst = 10;
Nframe = 10; % Number of total frame for simulation
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

% Initialize array to store the BER value for SNR simulation
% SNR value range from 30 dB to 10 dB with interval of 5 dB
% Array size is Nrow = (SNRdBmax/5dB) + 1, Ncol = Nframe
% Array row store information of BER value for each SNR
% The upper row contains BER value for higher SNR value
% Array column store information of BER value for each fraction in a frame
%           Frame 1     Frame 2  -----  Frame 10
% SNR30dB
% SNR25dB
% SNR20dB
% SNR15dB
% SNR10dB
% BERrow initialized before the start of SNR loop
% BERcol initialized at frame loop
BERsim = zeros(5,Nframe);

% Generate random binary data input
datain=randi([0 1],1,2800);

% Start the frame loop
for idx=(0:Nframe-1)

% Initialize the BER column index
BERcol = idx + 1;

% Initialize the frame data for this loop
frame_idx = idx*(Nact*Nburst)
framedat = datain(frame_idx+1:frame_idx+(Nact*Nburst));

% Convolutional encoding
% Uses industry-standard generator polynomial g0=133, g1=171
% Code rate : 1/2
constr_len = 7;
gen_poly = [133 171];
trellis = poly2trellis(constr_len,gen_poly);
codeword = convenc(framedat,trellis);

% Data interleaving
% Uses block interleaver with (Nrow=8, Ncol=70)
intrlvd = matintrlv(codeword',8,70);

% Reshape binary data into decimal for QPSK modulation
% Interleaved data reshaped into matrix with Nrow=2. Ncol=280
mod_in_bin = reshape(intrlvd, 2, 280);
mod_in_dec = bi2de(mod_in_bin','right-msb');

% QPSK modulation
mod_data = qammod(mod_in_dec,Nmod);
mod_data = reshape(mod_data,Nact,Nburst);
%scatterplot(mod_data);

% IFFTing the modulated data
% Copy the modulated data into array with Nrow = Nfft and Ncol = Nburst
% Modulated data copied into active subcarrier part of FFT, carrier 2 to 29
ifft_in = zeros(Nfft,Nburst);
dmt_sig = zeros(Nfft,Nburst);
for c=(1:Nburst)
    ifft_in(2:29,c) = mod_data(:,c);
end
for c=(1:Nburst)
    for i=(1:28)
        ifft_in(36+i,c)=ifft_in(30-i,c)'; % Hermitian symmetry
    end
end
for c=(1:Nburst)
    dmt_sig(:,c) = ifft(ifft_in(:,c),Nfft);
end

% Add cyclic prefix
dmt_sig_cp = zeros(Nfft+Ncp, Nburst);
for c=(1:Nburst)
    dmt_sig_cp(:,c) = vertcat(dmt_sig(Nfft-Ncp+1:Nfft,c), dmt_sig(:,c));
end

% Reshape dmt signal with cp into queue vector
dmt_sig_cp = reshape(dmt_sig_cp,(Nfft+Ncp)*Nburst,1);

% Transmitted signal + timing sequence
TxSym = vertcat(OFDMPreamb', dmt_sig_cp);

% Add symbol timing offset
timeOff = repmat(.05,1,32)';
TxSym_sto = vertcat(timeOff,TxSym);

% Initialize BER row index for simulation
BERrow = 1;

% Add AWGN noise
% Loop with 5 dB interval to plot BER vs SNR
for SNRdB=(SNRdBmax:-5:10)
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
    CEpos = M_maxidx - Ncp;
    
    % Dummy, just ignore...
    %TxSym_sto_awgn_sim = vertcat(TxSym_sto_awgn, repmat(TxSym_sto_awgn(DataStartPos:TxSymLen),9,1));
    % Dummy, just ignore...
    
    % Get the channel estimation symbol
    channel_est_sym = zeros(Nfft,Nce);
    for c=(1:2)
        CEpos = CEpos + Ncp;
        for r=(1:Nfft)
            channel_est_sym(r,c) = TxSym_sto_awgn(CEpos+r-1);
        end
        CEpos = CEpos + Nfft;
    end
    for c=(3:4)
        CEpos = CEpos + Ncp + Nfft + Ncp;
        for r=(1:Nfft)
            channel_est_sym(r,c) = TxSym_sto_awgn(CEpos+r-1);
        end
        CEpos = CEpos + Nfft;
    end 
    
    % Remove the cyclic prefix of each data burst
    % Stack each data symbol of data burst into the array column
    % Array size :  Nrow = Nfft,
    %               Ncol = Amount of data symbol in burst frame = Nburst
    DataSymbolArray = zeros(Nfft, Nburst);
    pos = DataStartPos;
    for c=(1:Nburst)
        pos = pos + Ncp;
        for r=(1:Nfft)
           DataSymbolArray(r,c) =  TxSym_sto_awgn(pos+r-1);
        end
        if (c<Nburst)
            pos = pos+Nfft;
        end
    end
    
    %FFTing channel estimation sequence
    fft_out_ce = zeros(Nfft, Nce);
    for c=(1:Nce)
        fft_out_ce(:,c) = fft(channel_est_sym(:,c),Nfft);
    end
    
    % FFTing data symbol
    fft_out_data = zeros(Nfft, Nburst);
    for c=(1:Nburst)
        fft_out_data(:,c) = fft(DataSymbolArray(:,c),Nfft);
    end
    
    % Separates the active subcarrier of channel estimation symbol
    CEcarrier = zeros(Nact, Nce);
    for c=(1:Nce)
        for r=(1:Nact)
            CEcarrier(r,c) = fft_out_ce(r+1,c);
        end
    end
    CEcarrier_re = real(CEcarrier);
    
    % Separates the active subcarrier of data symbol
    datacarrier = zeros(Nact, Nburst);
    for c=(1:Nburst)
        for r=(1:Nact)
            datacarrier(r,c) = fft_out_data(r+1,c);
        end
    end
    
    % Channel estimating
    channel_est = zeros(Nact,1);
    for r=(1:Nact)
        channel_est(r,1) = (CEcarrier_re(r,1)+CEcarrier_re(r,2)+CEcarrier_re(r,3)+CEcarrier_re(r,4))/4;
    end
    channel_est = abs(channel_est);
    
    % Equalizing
    eq_out = zeros(Nact,Nburst);
    for c=(1:Nburst)
        for r=(1:Nact)
            eq_out(r,c) = datacarrier(r,c)/channel_est(r,1);
        end
    end
    
    % QPSK demodulation
    demod_data = zeros(Nact,Nburst);
    for c=(1:Nburst)
        for r=(1:Nact)
            demod_data(r,c) = qamdemod(eq_out(r,c),Nmod);
        end
    end
    
    % Reshape burst array into queue vector
    demod_data = reshape(demod_data, 1, Nact*Nburst);
    
    % Convert into binary
    % Shape into queue vector
    demod_data_bin = de2bi(demod_data)';
    demod_data_bin = reshape(demod_data_bin, Nact*Nburst*Nmod/2,1);
    
    % Data deinterleaving
    % Uses block deinterleaver with (Nrow=70, Ncol=8)
    % Dimension of this block deinterleaver is the opposite of block
    % interleaver, which is (Nrow=8, Ncol=70)
    deintrlvd = matintrlv(demod_data_bin,70,8)';
    
    % Viterbi decoding
    dataout = vitdec(deintrlvd,trellis,5,'trunc','hard');
    diff = xor(framedat,dataout);
    
    % Store the BER value
    % Increment the row index for next SNR value
    BERsim(BERrow, BERcol) = nnz(diff);
    if (SNRdB < SNRdBmax)
        BERrow = BERrow + 1;
    end
    
end

end
% End of the frame loop

% Calculate the bit error rate ratio
% BER = No of error in burst frame / Total number of data in burst frame
BER_sum = zeros(5,1);
for r=(1:5)
    BER_sum(r,1) = sum(BERsim(r,:),2);
end
BER = BER_sum/(Nact*Nburst*Nframe);