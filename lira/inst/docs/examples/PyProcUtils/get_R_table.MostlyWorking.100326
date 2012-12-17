import numpy as n
import pyfits

def get_R_table( InRTxtFileName, \
    header = True, sep=' ', nrows=-1, skip=0, comment_char = "#" ):

    ## Initialize handy variables:

    ##  Read in file into one long string:
    image_in = open(InRTxtFileName,'r')

    ##  Parse it line-by-line, following "R" format:
    lline = -1
    OutTable = []
    header_read = False
    for this_line in image_in :
        lline += 1
        if (this_line[0] != comment_char) and (lline <= nrows or nrows < 0):
            if( lline > skip ) :
                if( header and not header_read ) :
                ##  Get header and number of variables, to start, following R-form:
                    header_line = this_line
                    header_string_vec = header_line.split(sep)
                    # cleanup:
                    num_extra = header_string_vec.count('')
                    for iextra in range(num_extra):
                        header_string_vec.remove('')
                    try:
                        header_string_vec.remove('\n')
                    except:
                        continue
                    #end Cleanup
                    num_of_cols = len(header_string_vec)
                    print '\n** get_Rfile_ascii_table_params: lline:', lline
                    print '** get_Rfile_ascii_table_params: number of columns:', num_of_cols,
                    print 'from header line:\n', header_string_vec
                    print
                    header_read = True
                elif (not header and not header_read ):
                    header_string_vec = this_line.split(sep)
                    # cleanup:
                    num_extra = header_string_vec.count('')
                    for iextra in range(num_extra):
                        header_string_vec.remove('')
                    try:
                        header_string_vec.remove('\n')
                    except:
                        continue
                    #end Cleanup
                    num_of_cols = len(test_string_vec)
                    header_string_vec = num_of_cols*['',]
                    print '\n** get_Rfile_ascii_table_params: lline:', lline
                    print '\n** get_Rfile_ascii_table_params: number of columns:', num_of_cols,
                    print 'from 1st line:\n', test_string_vec
                    print
                    header_read = True
                #End-if-header
                else: # Must be real data:
                    line_nums_vec = this_line.split(sep)
                    print '\n** get_Rfile_ascii_table_params: lline:', lline,
                    # cleanup:
                    num_extra = line_nums_vec.count('')
                    for iextra in range(num_extra):
                        line_nums_vec.remove('')
                    try:
                        line_nums_vec.remove('\n')
                    except:
                        continue
                    #end Cleanup
                    #
                    print line_nums_vec
                    if( num_of_cols != len(line_nums_vec) ):
                        print 'Fatal get_Rfile_ascii_table_params error.'
                        print 'First line indicated ', num_of_cols,' columns. '
                        print 'But line indicates ',len(line_nums_vec),'\n', line_nums_vec
                        print
                        raise TypeError
                    #
                    # Turning the string list into a numbers list:
                    nums_vec = []
                    for icol in range(num_of_cols):
                    #    print '\n** get_Rfile_ascii_table_params: line_nums_vec[icol]: ',line_nums_vec[icol]
                    #    print 'Type( nums_vec) = ', type(nums_vec),' Type(line_nums_vec[icol])=',type(line_nums_vec[icol])
                        nums_vec.append( float(line_nums_vec[icol]) )
                    #
                    OutTable.append(nums_vec)
                #End-if-header-or-data
            #End-if-lline > nskip
        #end-if-not-comment  and (lline < nrows or nrows < 0)
    #end-for-this_line

    return [header_string_vec, n.asarray(OutTable) ]
