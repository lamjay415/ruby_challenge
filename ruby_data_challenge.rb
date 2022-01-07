#function that reads input file and returns an array of row entries stored in hash objects
def processFile(location, headerStart, dataStart, containRowNumber)

    #reads file with input file location
    input = File.open(location, File::RDONLY){|f| f.read}
    header = input.lines[headerStart].split(' ')
    data = []

    #splits table into rows with given line number to start processing data
    inputData = input.lines[dataStart...input.lines.length-1].map{|line| line.split(' ')}

    #for each row, remove any unneccessary/extra lines and symbols, and assign each attribute data to the corresponding column 
    inputData.each do |entry|
        
        tempObj = {}
        
        #if data has row number column, ignore the column. ie: soccer.dat
        if(containRowNumber)
            entry = entry.slice(1,entry.length);
        end

        #if data has any line breaks, remove row. ie: --------- 
        entry.delete('-');

        #assign each attribute to table header and store in a hash object
        entry.each_with_index do |column, idx|
            
            column = column.tr('!@#$%^&*()-','')
            tempObj[header[idx]] = column

        end
        
        #if a row is empty, skip row
        if(tempObj.values != [])
            data.push(tempObj);
        end

    end

    data
end

#calcualte the smallest spread between two data columns and return the object 
def getSmallestSpread(data, stat1, stat2)

    result = {}
    min = 999999

    data.each do |d|
        curMin = (d[stat1].to_i - d[stat2].to_i).abs()
        if( curMin < min)
            min = curMin
            result = d
        end
    end

    result

end

weatherData = processFile('./w_data.dat',4,6,false)
soccerData = processFile('./soccer.dat',2,3,true)

puts "The day with the smallest temperature spread is day #{getSmallestSpread(weatherData,'MxT', 'MnT')['Dy']}"
puts "The team with the smallest difference in for and against goals is #{getSmallestSpread(soccerData, 'F', 'A')['Team'].tr('_',' ')}"
