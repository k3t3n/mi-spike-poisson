function spike_main()

%%--Reads spike data from a input file which contains the spike train
% Refer to the README for details on the experimental dataset



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%--Enter file path for the experiment session file
% Two sample .mat files are available for download. Each file is a "session"

file_names{1} = {'trial1K_1.mat'};          % Stimulus was presented. 1Khz tone at 53dbSPL
%file_names{1} = {'trialSilence_1.mat'};    % No Audio stimulus

%%--Additional session files can be input as shown below
% file_names{2} = {'trial1K_2.mat'};
% file_names{3} = {'trial1K_3.mat'};

clc; close all;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%--Miscellaneous Parameters to Set

%%--Plot the fitted histogram
plotFittedHist  = false;

%%--Plot the detected spikes
plotSpikeDetect = false;

%%--Plot the voltage threshold to visualize the cutoff over a background of the spike sequence
plotVoltageThreshCutoff = false;

%%--Spike width (number of samples)
spikeSize = 40;

%%--Select threshold constant
c  = 4.5; %generally c is consant between 3 and 5




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-Iterate through all sessions (in case you have loaded more than 1 session file)
for session_num = [1] 

    load( cell2mat(file_names{session_num}) , 'trial')  %load the trial data

    %-Choose electrode numbers
    for electrode_num = [1:7];

        int_arr_time = cell(1,size(trial,2));           %initialization

        %-Iterates through all repetitions in a given trial.
        for k = 1:size(trial,1)

            %%-Spike sequence
            x = trial{k}(electrode_num,:);


            %%-Remove noise spikes
            noise_tresh = 2.3*10^(-4); %specify a treshold to remove
            noiseWidth = 80;           %specify the number of sample to remove before and after a noise spike is detected
                                       %here the default is 80 (i.e., a total 161 samples are removed)
            for i = 1:size(x,2)
                if abs(x(i))>noise_tresh
                    if i < noiseWidth
                        x(i) = 0;
                    elseif i > size(x,2)-noiseWidth
                        x(i) = 0;
                    else
                        x(i-noiseWidth:i+noiseWidth)=zeros(1,noiseWidth*2+1);
                    end
                end
            end
            %%-End noise removal


            %%-Set votlage threshold limit for spike detection
            sn = median(abs(x))/0.6745;
            vt = c*sn;

            %%-Perform Spike Detection
            %%-If the voltage amplitude is greater than the set voltage threshold limit, it is declared to be a spike
            x_pulse = zeros(1,size(x,2));
            for i = (spikeSize/2)+1:size(x,2)-(spikeSize/2)
                if (abs(x(i))>vt) && ( abs(x(i)) == max(abs(x(i-(spikeSize/2):i+(spikeSize/2)))) )
                    x_pulse(i)=x(i);
                end
            end

            no_pulse_cut=0;
            for i = 1:size(x,2)
                if x_pulse(i)~=0
                    no_pulse_cut = no_pulse_cut+1;
                    cut_pulse{no_pulse_cut} = x(i-(spikeSize/2):i+(spikeSize/2));
                end
            end
            cut_pulse_realigned = cell(1,no_pulse_cut);
            for i=1:no_pulse_cut
                cut_pulse_realigned{i} = zeros(1,spikeSize*2+3);
                [m, ind] = min(cut_pulse{i});
                cut_pulse_realigned{i}(spikeSize+2-ind:spikeSize*2+2-ind)=cut_pulse{i};
                if (plotSpikeDetect==true)
                    hold on; plot(cut_pulse{i}); grid on;
                end
            end

            %%- Once spikes have been detected, calculate the arrival time of the corresponding spikes
            arr_time = find(x_pulse);

            if numel(arr_time)>0
                int_arr_time{k}(1)=arr_time(1);
                for i = 2:size(arr_time,2)
                    int_arr_time{k}(i) = floor(arr_time(i)-arr_time(i-1));
                end
                if (plotVoltageThreshCutoff == true)
                    figure,
                    stem(x_pulse, 'g'); grid on; hold on; plot(x); hline = refline([0 vt]); hline = refline([0 -vt]);
                end
            else continue;
            end


        end %k

        % Calulate the mean spiking rate "lambda", for every electode, for all sessions
        lambda{session_num}{electrode_num} = floor( histogram_fit( int_arr_time , electrode_num, plotFittedHist)/40 ); % flooring - divides the rate appropriately to adjust for the #samples in a window

        % This is where we can plug in code to calculate other key parameters %
        % For example
        %           <Insert code to calculate minimum first spike latency MFSL>
        %           MFSL{session_num}{electrode_num} =
        %

    disp( strcat(['Estimated lambda for electrode ',int2str(electrode_num), ' is: ', num2str(lambda{session_num}{electrode_num})]) )
    end %electrode_num


end %session_num

% Finally save the key parameters for each trial type in a .mat file.
% If a new key parameter is calculated it will be saved in this .mat file
disp(' ');disp('******************************************************')
disp('Lambda values successfully saved in file, ''lambda.mat''')
save lambda.mat lambda;

%exit

end %main()






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Poisson Fit %
% This function calculates and returns the mean spiking rate "lambda" by fitting the data to a poisson distribution
function lambda = histogram_fit(int_arr_time, electrode_num, plotFittedHist)

%load int_arr_time_go;
h = [];
for i = 1:size(int_arr_time,2)
    if ~isempty(int_arr_time{i})
        h = [h, int_arr_time{i}];
    end
end

if ~isempty(h)
    pd = fitdist(h', 'Exponential');
    x = [1:max(h)];
    e = exppdf(x , pd.mu);
    lambda = pd.mu;
else
    lambda = 0;
end
if plotFittedHist == true
    figure, histogram(h , 'Normalization' , 'pdf'); title(strcat(['Electrode Number ',int2str(electrode_num)]));
    xlabel('Inter-Spike Interval (number of samples)'); ylabel('Probability');
    hold on; plot(e, 'LineWidth',2);
    legend('Normalized Histogram','Fitted Exponenetial Distribution')
end

end %histogram_fit()
