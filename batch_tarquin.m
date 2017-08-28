% batch tarquin analysis

clear
% run everything from:
path_home='/home2/jstout/Data/tarquin_matlab_qui/test_data';
% path_home=uigetdir('.','Select data parent folder'); % comment out this line and hardcoded path above will work
cd(path_home)

%% generate rda_list
% assume you want to run anlaysis on all the *.rda files saved under path_home
% Get a list of all files and folders in this folder.
files = dir()
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir]
% Extract only those that are directories.
subFolders = files(dirFlags)
rdainfo=struct();
l=0
for idx=3:length(subFolders)
rda_list=dir(sprintf('./%s/*.rda',subFolders(idx).name));
for jdx=1:length(rda_list)
l=l+1
    rdainfo(l).fname=sprintf('%s/%s/%s',path_home,subFolders(idx).name,rda_list(jdx).name);
rdadump=rda_read(sprintf('./%s/%s',subFolders(idx).name,rda_list(jdx).name));
rdainfo(l).TE=rdadump.TE;
rdainfo(l).pname=strtrim(rdadump.PatientName);
rdainfo(l).pname=rdainfo(l).pname(1:4); %save only the subject number
rdainfo(l).date=strtrim(rdadump.StudyDate);
rdainfo(l).dir=fileparts(rdainfo(l).fname);
end
end

% For each line of rdainfo run the tarquin analysis using the code below
path_out=[path_home,'/tarout/'];
mkdir(path_out)

for idx=1:length(rdainfo)
        % generate the appropriate CONTROL file

        pathc_cntrl=[rdainfo(idx).dir '/' rdainfo(idx).pname '_' num2str(rdainfo(idx).TE) '_tarquin.control'];
        fid=fopen(pathc_cntrl,'w')
        
        % paramters below should be modified to fit your data
        fprintf(fid,['input %s\n'...
            'format rda\n'...
            'ref_signals 1h_naa_cr_cho\n'...
            'pul_seq laser\n'...
            'rows 6\n'...
            'cols 6\n'...
            'slices 2\n'...
            'output_csv %s%s_%03i_output.csv\n'...
            'output_fit %s%s_%03i_fit.csv\n'...
            'output_txt %s%s_%03i_txt.txt\n'],...
            rdainfo(idx).fname,...
            path_out,rdainfo(idx).pname,rdainfo(idx).TE,...
            path_out,rdainfo(idx).pname,rdainfo(idx).TE,...
            path_out,rdainfo(idx).pname,rdainfo(idx).TE);
        fclose(fid)
        
        % run tarquin
        cmdstr=sprintf('tarquin --para_file %s',pathc_cntrl) % this assumes that tarquin is in your path
        system(cmdstr,'-echo')
end


% add the tarquin data to the rdainfo file, to minimize loading time in the
% GUI
for idx=1:length(rdainfo)
    pathc=sprintf('%s%s_%03i_fit.csv',path_out,rdainfo(idx).pname,rdainfo(idx).TE);
    rdainfo(idx).data=tarquin_read_fitcsv(pathc);
end
save([path_out 'rdainfo_withdata.mat'],'rdainfo')
