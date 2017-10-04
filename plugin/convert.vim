if !has('python')
    echo "Error: Required vim compiled with +python"
    finish
endif

function! Int2Bin()
python << EOF

""" This plugin converts an integer at cursor to binary and hex """

import vim

def get_current_pos():
    y_pos, x_pos = vim.current.window.cursor
    return y_pos, x_pos


def get_visual():
    start, end = get_visual_range
    lines = get_range(start[0], start[1], end[0], end[1])
    return lines


def get_range(start_y, start_x, end_y, end_x):
    # start, end = [line_no, col]
    selected = buf[start_y-1:end_y]
    selected[0] = selected[0][start_x:]
    selected[-1] = selected[-1][:end_x+1]
    return selected


def get_current_number():
    # Get the number at cursor position
    y_pos, x_pos = get_current_pos()
    line = buf[y_pos-1]
    number = ""
    
    # Find the beginning of the number
    for i in range(x_pos, -1, -1):
        if not is_int(line[i]):
            break
        x_pos = i

    # go forward en start saving letters
    for i in range(x_pos, len(line)):
        if not is_int(line[i]):
            break
        number += line[i]

    return number


def is_int(number):
    try:
        return int(number)
    except:
        return False


def convert(number):
    return "{0:d} {0:#010b} 0x{0:X}".format(int(number))


buf = vim.current.buffer
number = get_current_number()

if is_int(number):
    print(convert(number))
else:
    print("No int found at cursor")


EOF
endfunction
