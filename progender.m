clc;
clear all;
close all;


Fs = 44100;
recObj = audiorecorder(Fs,16,1);
disp('Start speaking...');
recordblocking(recObj, 2);
disp('Recording finished.');
y = getaudiodata(recObj);

t = (0:length(y)-1)/Fs;
figure;
plot(t,y);
xlabel('Time (s)');
ylabel('Amplitude');
title('Recorded Voice Waveform');

y = y-mean(y);
N = length(y);

[acor,lag] = xcorr(y);
acor = acor(lag>=0);
lag = lag(lag>=0);

minLag = floor(Fs/500);
maxLag = floor(Fs/50);

[~,I] = max(acor(minLag:maxLag));
I = I+minLag-1;
pitchFreq = Fs/I;

if pitchFreq<165
    gender = 'Male';
elseif pitchFreq>=165 && pitchFreq<=255
    gender = 'Female';
else
    gender = 'Unknown/High pitch';
end

fprintf('Estimated Pitch Frequency: %.2f Hz\n',pitchFreq);
fprintf('Predicted Gender: %s\n',gender);

figure;
spectrogram(y,256,200,1024,Fs,'yaxis');
title('Spectrogram of Recorded Voice');
colormap jet;