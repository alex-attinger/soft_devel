function [ out ] = giveOutScore( f_vec,classifier,score_out )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[~, score] = classifier.predict(f_vec);

out = score(score_out);

end

