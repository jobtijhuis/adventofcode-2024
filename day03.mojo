from python import Python

fn main() raises:

    example_data = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"

    re = Python.import_module("re")
    muls = re.findall(r"mul\(([0-9]+),([0-9]+)\)", example_data)

    total_sum_ex = 0
    for x in muls:
        total_sum_ex += atol(str(x[0])) * atol(str(x[1]))

    print(String("example total: {}").format(total_sum_ex))

    example_data_2 = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

    muls_2 = re.findall(r"(mul|do(?:n't)*)\((?:([0-9]+),([0-9]+))*\)", example_data_2)

    for x in muls_2:
        print(x)

    with open("input/day03.txt", 'r') as file:
        input_data = file.read()
        muls = re.findall(r"mul\(([0-9]+),([0-9]+)\)", input_data)

        total_sum_1 = 0
        for x in muls:
            total_sum_1 += atol(str(x[0])) * atol(str(x[1]))
    
        print(String("part 1 total: {}").format(total_sum_1))

        muls_2 = re.findall(r"(mul|do(?:n't)*)\((?:([0-9]+),([0-9]+))*\)", input_data)

        total_sum_2 = 0
        enabled = True
        for x in muls_2:
            if x[0] == "mul":
                print(x)
                if enabled:
                    total_sum_2 += atol(str(x[1])) * atol(str(x[2]))
            elif x[0] == "do":
                enabled = True
            elif x[0] == "don't":
                enabled = False

        print(String("part 2 total: {}").format(total_sum_2))

        
