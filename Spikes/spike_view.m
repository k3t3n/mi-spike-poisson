function [individual_trial, trial_log] = spike_view( file )
%%-SPIKE_VIEW
% This function reads data from .hd5 file (for a session)
% Splits the session into individual trials along with the corresponsding trial log
% Applies a bandpass filer to the spike data

info = hdf5info(file);
info = info.GroupHierarchy.Groups.Name;
data = h5read(file,[info,'/data/physiology/raw']);
trial_log = h5read(file,[info,'/data/trial_log']);

% Bandpass the raw data %
low_cutoff  = 300;      % lower cut-off frequency in Hz
high_cutoff = 4000;     % higher cut-off frequency in Hz
Fs  = 24414.0625;       % sampling freqeuncy in Hz
[b,a] = butter(6,[low_cutoff,high_cutoff]/(Fs/2));
filtered_data = filtfilt(b,a,double(data));

% The data is continuous. If you want to look at an individual trial, this is how you could access it (brute force):

lb = -1; % how many seconds before sound onset should be analyzed
ub = 1; % how many seconds after sound offset should be analyzed
sound_duration = 1; % 1 second long tone
end_time= trial_log.start + sound_duration + ub; %sound duration happens to be 1 second
start_time = trial_log.start + lb;


% Save individual_trial "it" and trial_log "tl" for each session
for j=1:size(filtered_data,2)
    for i=1:size(trial_log.start,1)
        individual_trial{i,j} = filtered_data(round(Fs*(start_time(i,1))):round(Fs*end_time(i,1)),j);
    end
end

end %spike_view()
