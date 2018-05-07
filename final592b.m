% Set up data; sheet 1 contains all of the pitch and intensity information 
file = 'output.xlsx';
sheet = 1;
xlRange = 'B2:G412370';
[sentencenumber, numericaldata, alldata] = xlsread(file,sheet,xlRange);

%Sheet 2 contains binary 0/1 indexing of what sentences should and should
%not have pauses; 0 = no pause 1 = pause
file = 'output.xlsx';
sheet = 2;
xlRange = 'A1:B100';
[sentencenumber_test, numericaldata_test, sentence_data] = xlsread(file,sheet,xlRange);

%This is all of the sentences in the directory
full_sentence_list = {'Filler 26', 'Filler 27', 'Filler 28', 'Filler 30', 'Filler 31', 'Filler 32', 'Filler 33', 'Filler 34', 'Filler 36', 'Filler 37', 'Filler 39', 'Filler 40', 'Filler 41', 'Filler 42', 'Filler 47', 'Filler 49', 'Filler 51', 'Filler 53', 'Filler 55', 'Filler 57', 'Filler 60', 'Sentence 1', 'Sentence 2', 'Sentence 5', 'Sentence 6', 'Sentence 7', 'Sentence 8', 'Sentence 9', 'Sentence 10', 'Sentence 13', 'Sentence 14', 'Sentence 17', 'Sentence 18', 'Sentence 21', 'Sentence 22', 'Sentence 24', 'Sentence 25', 'Sentence 26', 'Sentence 27', 'Sentence 28', 'Sentence 29', 'Sentence 30', 'Sentence 31', 'Sentence 32', 'Sentence 33', 'Sentence 34', 'Sentence 35', 'Sentence 36', 'Sentence 41', 'Sentence 42', 'Sentence 43', 'Sentence 44', 'Sentence 45', 'Sentence 46', 'Sentence 53', 'Sentence 54', 'Sentence 57', 'Sentence 58', 'Sentence 59', 'Sentence 60', 'Sentence 61', 'Sentence 62', 'Sentence 65', 'Sentence 66', 'Sentence 67', 'Sentence 68', 'Sentence 69', 'Sentence 70', 'Sentence 71', 'Sentence 72', 'Sentence 73', 'Sentence 74', 'Sentence 77', 'Sentence 78', 'Sentence 79', 'Sentence 80', 'Sentence 81', 'Sentence 82', 'Sentence 83', 'Sentence 84', 'Sentence 85', 'Sentence 86', 'Sentence 89', 'Sentence 90', 'Sentence 91', 'Sentence 92', 'Sentence 93', 'Sentence 94', 'Sentence 95', 'Sentence 96', 'Sentence 97', 'Sentence 98', 'Sentence 99', 'Sentence 100', 'Sentence 101', 'Sentence 102', 'Sentence 103', 'Sentence 104', 'Sentence 105', 'Sentence 106'}; 

%This is a subset of 50 for testing and a subset of 50 for the final run
sentences = numel(full_sentence_list);
all_sent_perm = full_sentence_list(randperm(sentences));
test_sentences = all_sent_perm(1:50);
final_sentences = all_sent_perm(51:end);




%%% RUN 1 %%%
pause_detector(alldata, sentence_data, sentence_list, 0, .1, 21, 25, 75, 51)
%Testing 21 values between 0dB and .1dB (steps of .002) against 51 values between 25
%samples and 75 samples (steps of 1).

%This run identified that the threshold should be less than .005 an the
%duration values don't seem to significantly matter. They do get less
%accurate as the duration increases, so I will constrain it a bit.



%%% RUN 2 w/ adjusted threshold %%%
pause_detector(alldata, sentence_data, sentence_list, 0, .005, 6, 25, 50, 26) 
%Testing 6 values between 0dB and .005dB (steps of .001) against 51 values between 25
%samples and 75 samples (steps of 1).

%This run also showed that the intensity data needs to be really low
%(<.001). Duration increase still reduces accuracy, but I'll still test
%25-50 in the future.


%%% RUN 3 w/ adjusted threshold %%%
pause_detector(alldata, sentence_data, sentence_list, 0, .001, 11, 25, 50, 26) 
%Testing 11 values between 0dB and .001dB (steps of .0001) against 51 values between 25
%samples and 75 samples (steps of 1).

%I've chosen final values of 0dB and 35 samples.



%%% RUN 4 w/ these chosen values %%%
pause_detector(alldata, sentence_data, final_sentences, 0, 0, 1, 0, 35, 1) 

% 1: 96 percent correct rate (48 correct)



% Next steps?
% Use pitch information pre-pause to see if that can help identify the four
% that were incorrectly identified
%I have more sentences I could test, but they all have pauses



 
 % next step, introduce other fillers with pauses? look at pitch
 % characteristics before where the pause is identified? ~100ms before
 % first 0 in pause, make a plot. then write a thing to make it work so it
 % look at pitch or pause, see if that increases beyond 96
 % rename alldata_test
 
