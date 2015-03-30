clear
close all

[source,fs] = audioread('sheismysin.wav');      % Read source
x = source(:,1);                                % Select a channel
L = size(x,1);                                  % Audio length
N = 1024;                                       % N of FFT
N2 = ceil((N+1)/2);                             % Half N
H = floor(N/4);                                 % Hop size
F = ceil((L-N)/H);                              % No. of frames
X = spectrogram(x,hann(N),N-H,N,fs);            % STFT
M = abs(X);                                     % Spectrum Magnitude

%% Energy
DSE = sum(M(:,2:end)-M(:,1:end-1),1);           % DSE
TM = 0.3*sum(M(:,1:end-1),1);                   % Magnitude threshold
MarkE = DSE>TM;                                 % Mark


%% Phase
WX = M./repmat(sum(M),N2,1);
P = unwrap(angle((X)));
PDA = P(:,3:end)-2*P(:,2:end-1)+P(:,1:end-2);
PD = abs(sum(PDA.*WX(:,2:end-1),1));
TP = 35*pi;
MarkP = PD(2:end)>TP;


%% Complex domain
%stem(MarkP)
%hold on
%stem(MarkE(2:end-1),'r')
m=size(M,2);
delta=5.95;
lamda=1;
disc=zeros(m);
MarkC=zeros(1,m-H);
PhaseArray = unwrap(angle(X));
EstimatedPhase=princarg(2*PhaseArray(:,2:end-1)-PhaseArray(:,1:end-2));
EstimatedSig=M(:,2:end-1).*exp(1j*EstimatedPhase);
ComDist=sum(sqrt((real(EstimatedSig)-real(X(:,3:end))).^2+(imag(EstimatedSig)-imag(X(:,3:end))).^2),1);

threshold=zeros(1,m-H-1);
NoT=length(threshold);
for i =1:NoT;
    threshold(i)=delta+lamda*median(ComDist(i:i+H-1)); %moving median solvable for matrix?
end
MarkC=ComDist(H/2:end-H/2)>threshold(1:end);
MarkC=[zeros(1,H/2),MarkC,zeros(1,H/2)];

stem(MarkP)
hold on
stem(MarkE(2:end-1),'r')
hold on
stem(MarkC,'k')
%source=audioread('darkchestofwonders.wav');
%x = source(:,1)'; 
%y = source(:,2)'; second track
%N = length(x);

% Compute STFT

%R = 512;                
%Nfft = 1024;       
%X = stft(x, R, Nfft); 
    
% Energy
% m=length(X(1,:));
% dse=zeros(1,m);
% marke=zeros(1,m);
% marked=zeros(1,m);
% for i=2:m
%     
% dse(i)=sum(abs(X(:,i)-abs(X(:,i-1))));
% delta=0.3*sum(abs(X(:,i-1)));  %assumed threshold
% if dse(i)>delta
%     marke(i)=1;
% end
% end       
    

%dsp=zeros(1,m);
%markp=zeros(1,m);
%markpd=zeros(1,m);
%deltap=0.2*pi;

%for i=1:m-1
%    uX(:,i)=abs(X(:,i))/(sum(abs(X(:,i)))); % weighting matrix
%if i<=3
%    dsp(i)=0;
%else
%PhaseArray=unwrap([angle(X(:,i-2)),angle(X(:,i-1)),angle(X(:,i))]);
%    pf=PhaseArray(:,3)-2*PhaseArray(:,2)+PhaseArray(:,1);
%    dsp(i)=sum(abs(princarg(pf'*uX(:,i))));
%    if dsp(i)>deltap
%        markp(i)=1;
%    end
%end
%display(i);
%end
%
%PhaseArray=((unwrap(angle(X(:,3:end)),pi,2)).*WX(:,3:end)-(2*unwrap(angle(X(:,2:end-1)),pi,2)).*WX(:,2:end-1)+(unwrap(angle(X(:,1:end-2)),pi,2)).*WX(:,1:end-2));

%for i=1:m-1
%    uX(:,i)=abs(X(:,i))/(sum(abs(X(:,i))));
%    if i<=3
%        dsc(i)=0;
%    else
%
%        PhaseArray=unwrap([angle(X(:,i-1)),angle(X(:,i))]);
%        ep=princarg(2*PhaseArray(:,2)-PhaseArray(:,1));
%        amp=abs(X(:,i-1));
%        estsig=amp'*exp(1j*ep);
%        disc(i)=sum(sqrt(real((estsig-X(:,i))).^2+(imag(estsig-X(:,i))).^2)); 
%    end
%        
%deltac=5; % random constant?
%lamda=1;
%if i<H % assuming the first non-zero index is smaller than half width of median filter
%    markc(i)=0;
%else
%    eta=median(disc(i-H/2:i+H/2));
%    if disc(i-H/2)>=deltac+lamda*eta
%        markc(i-H/2)=1;
%    else
%        markc(i-H/2)=0;
%    end
%end
%display(i);
%end;