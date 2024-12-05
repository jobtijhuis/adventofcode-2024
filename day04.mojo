from max.tensor import Tensor, TensorSpec, TensorShape
from sys.info import simdwidthof
from testing import assert_true
from algorithm import vectorize, map, all_true, sum
from buffer import Buffer

from max.graph import Graph, TensorType, ops

# fn transpose(ts: TensorShape, x: Int, y: Int) -> TensorShape:
#     var res = ts
#     res[x] = ts[y]
#     res[x] = ts[y]
#     print(ts.num_elements())
#     for i in range(ts.rank()):
#         pass
#     return res

fn transpose[type: DType](data: Tensor[type]) -> Tensor[type]:
    width = data.shape()[0]
    height = data.shape()[1]
    var data_trans = Tensor[type](TensorShape(height, width))

    for i in range(data.shape()[0]):
        for j in range(data.shape()[1]):
            data_trans[i*height + j] = data[j*width + i]
    
    return data_trans

fn flip[type: DType](data: Tensor[type]) -> Tensor[type]:
    width = data.shape()[0]
    height = data.shape()[1]
    var data_flip = Tensor[type](TensorShape(height, width))

    for i in range(data.shape()[0]):
        for j in range(data.shape()[1]):
            data_flip[j*width + i] = data[j*width + width - i - 1]
    
    return data_flip

fn shift_diag[type: DType](data: Tensor[type]) -> Tensor[type]:
    width = data.shape()[0]
    height = data.shape()[1]
    var data_shift = Tensor[type](TensorShape(width, height+height-1))

    for j in range(data_shift.shape()[1]):
        for i in range(data_shift.shape()[0]):
            loc = j*width + i*width + i - width*(width-1)
            if loc < height*width and loc >= 0:
                data_shift[i + j*width] = data[loc]
            else:
                data_shift[i + j*width] = ord("0")

    return data_shift

fn reverse[type: DType](data: Tensor[type]) -> Tensor[type]:
    width = data.shape()[1]
    var res = Tensor[type](data.shape())
    for i in range(width):
        res[width - i - 1] = data[i]
    return res


fn print_tensor[type: DType](data: Tensor[type]):
    width = data.shape()[0]
    for j in range(data.shape()[1]):
        print("[", end="")
        for i in range(data.shape()[0]):
            print(chr(int(data[i + j*width])), end=",")
        print("]",)

fn print_bare_tensor[type: DType](data: Tensor[type]):
    width = data.shape()[0]
    for j in range(data.shape()[1]):
        for i in range(data.shape()[0]):
            print(chr(int(data[i + j*width])), end="")
        print("",)



fn main() raises:

    alias type = DType.uint8
    alias simd_type = SIMD[type, 4]
    # alias simd_width: Int = simdwidthof[type]()

    example_data_1 = String(
        "MMMSXXMASM\n"
        "MSAMXMSMSA\n"
        "AMXSXMAAMM\n"
        "MSAMASMSMX\n"
        "XMASAMXAMM\n"
        "XXAMMXXAMA\n"
        "SMSMSASXSS\n"
        "SAXAMASAAA\n"
        "MAMMMXMMMM\n"
        "MXMXAXMASX\n"
    )

    lines = example_data_1.splitlines()
    o_width  = len(lines[0])
    o_height = len(lines)

    data = Tensor[type](TensorShape(o_width, o_height))

    for y in range(o_height):
        line = example_data_1[y*o_width + y:y*o_width + y + o_height].as_bytes()
        print(example_data_1[y*o_width + y:y*o_width + y + o_height])
        for x in range(o_width):
            data.store(y*o_width + x, line[x])

    # data_trans = transpose(data)
    # data_shift = shift_diag(data)
    # data_trans_shift = shift_diag(data_trans)

    # print_tensor(data_trans_shift)

    # print(data)
    # print(data_trans)
    # print("shift:")
    # print(data_shift)

    test_string = String("MMMSXXMASM")
    test_data = Tensor[type](TensorShape(1,len(test_string)), test_string.as_bytes())

    print(test_data)

    xmas_string = "XMAS"
    xmas = Tensor[type](TensorShape(1,len(xmas_string)), xmas_string.as_bytes())

    fn num_match(x: Tensor[type], pattern: Tensor[type]) raises -> Int:
        pattern_simd = pattern.load[width=4](0)

        width = x.shape()[0]
        var num_matches = 0

        @parameter
        fn check_equal(idx: Int) -> None:
            value = x.load[width=4](idx)
            if width - (idx % width) >= 4:
                equal_simd = value == pattern_simd
                # result.store[width=1](idx, equal_simd.reduce_and())
                if equal_simd.reduce_and():
                    num_matches += 1

        map[check_equal](x.num_elements())

        return num_matches

    print(num_match(test_data, xmas))

    fn find_word_count(data: Tensor[type], pattern: Tensor[type]) raises -> Int:
        pattern_rev = reverse(pattern)

        data_trans = transpose(data)
        data_shift = shift_diag(data)
        data_flip_shift = shift_diag(flip(data))

        print("orig:")
        print_bare_tensor(data)
        print("trans:")
        print_bare_tensor(data_trans)
        print("shift:")
        print_bare_tensor(data_shift)
        print("trans_shift:")
        print_bare_tensor(data_flip_shift)

        horizontal = num_match(data, pattern)
        horizontal_rev = num_match(data, pattern_rev)

        print(String("horizontal: {}").format(horizontal))
        print(String("horizontal_rev: {}").format(horizontal_rev))

        vertical = num_match(data_trans, pattern)
        vertical_rev = num_match(data_trans, pattern_rev)

        print(String("vertical: {}").format(vertical))
        print(String("vertical_rev: {}").format(vertical_rev))

        diagonal_right = num_match(data_shift, pattern)
        diagonal_right_rev = num_match(data_shift, pattern_rev)

        print(String("diagonal_right: {}").format(diagonal_right))
        print(String("diagonal_right_rev: {}").format(diagonal_right_rev))

        diagonal_left = num_match(data_flip_shift, pattern)
        diagonal_left_rev = num_match(data_flip_shift, pattern_rev)

        print(String("diagonal_left: {}").format(diagonal_left))
        print(String("diagonal_left_rev: {}").format(diagonal_left_rev))

        return horizontal + horizontal_rev + vertical + vertical_rev + diagonal_right + diagonal_right_rev + diagonal_left + diagonal_left_rev

    total = find_word_count(data, xmas)

    print(String("total: {}").format(total))

    with open("input/day04.txt", 'r') as file:
        raw_data = file.read()
        o_width  = raw_data.find('\n')
        o_height = len(raw_data)//o_width
        print(o_height)

        part1_data = Tensor[type](TensorShape(o_width, o_height))

        for y in range(o_height):
            var line = raw_data[y*o_width + y:y*o_width + y + o_height].as_bytes()
            # print(raw_data[y*o_width + y:y*o_width + y + o_height])
            for x in range(o_width):
                part1_data.store(y*o_width + x, line[x])

        total_part1 = find_word_count(part1_data, xmas)

        print(String("total part 1: {}").format(total_part1))
