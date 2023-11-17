import os

type_dict = {
    'r': ['+', '-', '|', '&'],
    'i': ['+_', '<<_', '>>_', 'X|_'],
    '<-': ['<-'],
    '->': ['->'],
    'Y=': ['Y='],
    'Y<': ['Y<'],
    '\\/': ['\\/'],
    '/\\': ['/\\']
}

func_dict = {
    '+': '0000',
    '-': '0001',
    '|': '0010',
    '&': '0011',
    '+_': '00',
    '<<_': '01',
    '>>_': '10',
    'X|_': '11'
}

opcode = {
    'r': '000',
    'i': '001',
    '<-': '010',
    '->': '011',
    'Y=': '100',
    'Y<': '101',
    '\\/': '110',
    '/\\': '111'
}

mem_dict = {
    'x0': 0,
    'zero': 0,
    'ra': 1,
    'sp': 2,
    'at': 3,
    'a0': 4,
    'a1': 5,
    's0': 6,
    's1': 7
}


def int_to_bin(num, length=3):
    # Convert the integer to binary representation
    binary_str = bin(num & int("1"*length, 2))[2:]

    # Check if the length is greater than the length of binary_str
    if len(binary_str) < length:
        # If the number is negative, extend with 1s; otherwise, extend with 0s
        sign_extension = '1' if num < 0 else '0'
        # Calculate the number of bits to extend
        extend_bits = length - len(binary_str)
        # Perform sign extension
        binary_str = sign_extension * extend_bits + binary_str

    return binary_str


def find_type(op):
    for key, val in type_dict.items():
        if op in val:
            return key


def copy_file(source_file, destination_file):
    branch_dict = {}  # e.g.:   gcd : 13
    i = 0
    with open(source_file, 'r') as source:
        for line in source:
            tokens = line.split()
            if ':' in line:
                branch_dict[tokens[0][:-1]] = i
            i += 1
    doc_len = i
    i = 0
    with open(source_file, 'r') as source:
        with open(destination_file, 'w') as destination:
            for line in source:
                tokens = line.split()  # tokens = ['sp', '+_', '8,', 'sp']
                if ':' in line:  # branches
                    branch_dict[tokens[0][0:-1]] = i
                    del tokens[0]

                current_op = tokens[1]
                current_type = find_type(current_op)

                if current_type == 'r':
                    rs2 = int_to_bin(mem_dict[tokens[2][0:-1]])
                    rs1 = int_to_bin(mem_dict[tokens[0]])
                    rd = int_to_bin(mem_dict[tokens[3]])
                    assembled_line = func_dict[current_op] + rs2 + rs1 + rd + opcode[current_type]

                if current_type == 'i':
                    imm = int_to_bin(int(tokens[2][0:-1]), 5)
                    rs1 = int_to_bin(mem_dict[tokens[0]])
                    rd = int_to_bin(mem_dict[tokens[3]])
                    assembled_line = func_dict[current_op] + imm + rs1 + rd + opcode[current_type]

                if current_type in ['<-', '->']:
                    tmp = tokens[-1].split('+')
                    tokens.pop()
                    tokens.extend(tmp)
                    imm = int_to_bin(int(tokens[3]), 7)
                    rs1 = int_to_bin(mem_dict[tokens[2]])
                    rd = int_to_bin(mem_dict[tokens[0]])
                    assembled_line = imm + rs1 + rd + opcode[current_type]

                if current_type in ['Y<', 'Y=']:
                    imm = int_to_bin(branch_dict[tokens[3]] - i, 7)
                    rs2 = int_to_bin(mem_dict[tokens[2][0:-1]])
                    rs1 = int_to_bin(mem_dict[tokens[0]])
                    assembled_line = imm[0:4] + rs2 + rs1 + imm[4:7] + opcode[current_type]

                if current_type in ['/\\', '\\/']:
                    if current_type == '\\/':
                        imm = int_to_bin(branch_dict[tokens[2]] - i, 10)
                    else:
                        imm = int_to_bin(int(tokens[2]), 10)
                    rd = int_to_bin(mem_dict[tokens[0]])
                    assembled_line = imm + rd + opcode[current_type]

                assembled_line = int(assembled_line, 2)
                assembled_line = format(assembled_line, '04X')

                if i == (doc_len - 1):
                    write_string = assembled_line
                else:
                    write_string = assembled_line + '\n'

                destination.write(write_string)
                i += 1

    print(branch_dict)
    print(f"File '{source_file}' assembled to '{destination_file}'")


if __name__ == "__main__":
    source_file = 'program.txt'
    dest_path = os.path.join("implementation", 'memory.txt')
        
    if not os.path.exists(source_file):
        print(f"The source file '{source_file}' does not exist.")

    copy_file(source_file, dest_path)
