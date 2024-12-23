function DN = createDiary(diaryName)
DN = sprintf("%s-%s", diaryName, date);
eval(sprintf("diary %s",DN));
diary on
end