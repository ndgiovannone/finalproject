function pause_detector = pause_detector(alldata, sentence_data, test_sentences, lowerthreshold, upperthreshold, thresholdlength, lowerduration, upperduration, durationlength) 
%This function takes 9 input variables:
%alldata: pitch and intensity information from my sentences
%sentence_data: sentence names and whether they have pauses or not
%test_sentences: a sampling of the sentences in the directory
%lowerthreshold: the lowest dB value to test
%upperthreshold: the highest dB value to test
%thresholdlength: the number of dB values to test
%lowerduration: the smallest possible duration to test
%upperduration: the largest possible duration to test
%durationlength: the number of duration values to test

%Setting up matched lists of different intensity and duration threshholds
intensity_threshold_list = [linspace(lowerthreshold, upperthreshold, thresholdlength)]; %vector of thresholdlength values between lowerthreshold & upperthreshold
intensity_duration_list = [linspace(lowerduration, upperduration, durationlength)]; %vector of durationlength values between lowerduration & upperduration
intensity_repeat = repmat([intensity_threshold_list],1,durationlength)';%repeats the vector of intensities durationlength times, then flips the direction
intensity_list = sort(intensity_repeat); %sorts ascending-descending
duration_list = repmat([intensity_duration_list],1,thresholdlength)'; %repeats the vector of durations thresholdlength times, then flips the direction
threshold_duration = horzcat(intensity_list, duration_list); %concatenates vectors into a 2-column matrix

num_correct_vector = [0]; %This is a vector that will keep track of how many sentences were correctly identified as having/not having a pause for each combination of duration and intensity

for i=1:(thresholdlength * durationlength)
    threshold = threshold_duration(i,1);
    duration = threshold_duration(i,2);
    %threshold pulls the i-th value from the first column of
    %threshold_duration and duration pulls the i-th value from the second
    %column of threshold_duration. This for loop will loop through all rows
    %(thresholdlength * durationlength)
    
    num_correct = 0; %This is a counter

    for s=1:length(test_sentences) %all sentences
        sentence = test_sentences{s}; %cycles through the sentences assigned to sentence
       
        sentence_rows = find(strcmp([sentence, '.mat'],alldata)); %identifies the row numbers of this sentence and saves them
        first_row = sentence_rows(1,1); %identifies the first row of the sentence
        last_row = sentence_rows(end,1); %identifies the last row of the sentence
    
        start_row = first_row + 999; %starts analyzing each sentence 1 second in to avoid silences at the beginning of a file being identified as a pause
        end_row = last_row - 999; %stops analyzing each sentence 1 second from the end to avoid silences at the end of a file being identified as a pause
    
        sentence_intensity = alldata(start_row:end_row, 5); %pulls intensity information from the desired rows
        sentence_intensity_zeros = find([sentence_intensity{:}] == threshold); %finds rows in which the intensity == threshold
                    
        %This block of code creates an array of 0s and 1s based on the
        %array in which the intensity == threshold. If the samples are
        %consecutive, it is represented by a value of 1, if not, a 0. In
        %this way, calculations can be done to determine how many
        %consecutive samples are 0. For many sentences, there are multiple
        %places that could be considered a pause, so the output of this
        %section will be used to determine the longest stretch of
        %consecutive 0-intensity samples. This will be referred to as the
        %pause.
        consecutive_zero_rows = diff(sentence_intensity_zeros)==1; 
        num_consecutive_vector = [0]; %dummy vector which will later be edited
        start = 0; 
        zero_values = find(consecutive_zero_rows == 0); % finds the 0s in the array, which indicates the position where the consecutive samples end
        finish = length(consecutive_zero_rows) + 1;
        values = [start, zero_values, finish]; %creates a vector with first value 0, final value samples+1, middle values where the 0s are 

        %This for loop identifies how long each consecutive stretch of 0s
        %is and saves it to the previously created num_consecutive_vector
        for t = 2:length(values)
            a = values(1,(t)) - values(1,t-1) - 1;
            num_consecutive_vector = [num_consecutive_vector, a];
        end

        %The pause is the longest stretch of consecutive 0s.
        pause_duration = max(num_consecutive_vector);      
        
        if pause_duration >= duration; 
            y = 1; %if the pause is greater than or equal to the duration, y=1 because sentences with pauses are marked as 1 in the spreadsheet
        else
            y = 0; %if the pause is less than or equal to the duration, y=0 because sentences with pauses are marked as 0 in the spreadsheet
        end
        
        sentence_row = find(strcmp([sentence],sentence_data)); %locates this sentence in the sheet with the pause/no pause information
        pause_status = cell2mat(sentence_data(sentence_row,2)); %saves the 0 or 1 which indicates this sentence's pause status
   
        if isequal(y, pause_status)
           num_correct = num_correct + 1; %if the pause status of this sentence was correctly identified, the num_correct counter gets +1
        end
               
    end
    num_correct_vector = [num_correct_vector, num_correct]; %keeps a record of how many sentences were identified correctly for each combination of threshold and duration 
end

adj_num_correct_vector = [num_correct_vector(2:end)]; %gets rid of the dummy datapoint used to start the vector
adj_num_correct_vector = [adj_num_correct_vector]';

final_values = horzcat(threshold_duration, adj_num_correct_vector) %concatenates threshold, duration, and number correct into one dataframe 

num_correct %returns number correct for the most recent combination of threshold and duration. this is really only important when run the function the final time.

end

    