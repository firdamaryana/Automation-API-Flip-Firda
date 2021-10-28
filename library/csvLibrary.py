import csv
import urllib.request
import codecs

class csvLibrary(object):

    def read_csv_file(self, filename):
        '''This creates a keyword named "Read CSV File"

        This keyword takes one argument, which is a path to a .csv file. It
        returns a list of rows, with each row being a list of the data in 
        each column.
        '''
        data = []
        # with open(filename, 'rb') as csvfile:
        with open(filename, "rt", encoding="UTF8") as csvfile:
            reader = csv.reader(csvfile)
            for row in reader:
                data.append(row)
        return data
    
    def read_csv_url(self, url):
        '''This creates a keyword named "Read CSV URL"

        This keyword takes one argument, which is a path to a .csv file. It
        returns a list of rows, with each row being a list of the data in 
        each column.
        '''
        data = []
        csvfile = urllib.request.urlopen(url)
        csvfile = csv.reader(codecs.iterdecode(csvfile, 'UTF8'))
        for row in csvfile:
            data.append(row)
        return data

    def update_csv_content(self, data, row, column, inputtedData):
        '''This creates a keyword named "Update CSV Content" to update a cell of csv.
        '''
        inputtedRow= int(row)
        inputtedColumn= int(column)
        data[inputtedRow][inputtedColumn] = inputtedData
        return data

    def write_data_into_csv(self, filename, data):
        '''This creates a keyword named "Write Data Into CSV"

        This keyword to create a CSV file
        '''
        writer = csv.writer(open(filename, 'w'))
        writer.writerows(data)