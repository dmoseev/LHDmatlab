function [time, frq, spec1, spec2] = get_LHD_ICE2(shotnum)
%GET_LHD_ICE2 Returns LHD ICE spectrograms in teh range of several hundred
%of MHz. The data come from two probes in port 5.5u (spec1) and 6.5u
%(spec2)
%   
% It uses the LHD webservice 
%   https://exp.lhd.nifs.ac.jp/opendata/LHD/ for accessing the data.
%
%   Example
%       [time, frq, spec1, spec2] = get_LHD_ICE2(164423);
%
%   Created by: Dmitry Moseev (dmitry.moseev@ipp.mpg.de)
%   Version:    1.0
%   Date:       14.11.2022

time=[];
frq = [];
spec1 = [];
spec2 = [];

% Generic way to get string data
base_url = 'https://exp.lhd.nifs.ac.jp/opendata/LHD/webapi.fcgi';
cmd='getfile';
diag = 'ICH-ICE2';
shot=num2str(shotnum,'%i');
subno = num2str(1,'%i');
url = [base_url '?cmd=' cmd '&diag=' diag '&shotno=' shot '&subno=' subno];
options = weboptions("ContentType", "text");
rawdata=webread(url,options);
strdata=string(rawdata);

% Now need to dissect
temp=split(strdata,'[data]'); % last element contains data
%header = temp(1)
% fltdata=sscanf(temp(end),'%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f',[23, Inf]);
fltdata = str2num(temp(end))';

% Return values
time=unique(fltdata(1,:));
frq = unique(fltdata(2,:));
% R = R(1:length(R)/length(time));
dimsize=[length(frq),length(time)];
spec1 = reshape(fltdata(3,:),dimsize);
spec2 = reshape(fltdata(5,:),dimsize);

end