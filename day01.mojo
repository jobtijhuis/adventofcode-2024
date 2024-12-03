from python import Python
from utils.static_tuple import StaticTuple

fn zip[type: AnyTrivialRegType](x: List[type], owned y: List[type]) -> List[StaticTuple[type, 2]]:
    output = List[StaticTuple[type, 2]]()

    y.reverse()
    
    for i in x:
        output.append(StaticTuple[type, 2](i[], y.pop()))

    return output

fn zipint(x: List[Int], owned y: List[Int]) -> List[StaticTuple[Int, 2]]:
    output = List[StaticTuple[Int, 2]]()

    y.reverse()
    
    for i in x:
        output.append(StaticTuple[Int, 2](i[], y.pop()))

    return output

fn main() raises:

    re = Python.import_module("re")

    example_data_1 = List(
        "3   4",
        "4   3",
        "2   5",
        "1   3",
        "3   9",
        "3   3",
    )

    left  = List[Int]()
    right = List[Int]()
    pattern = re.compile(r"^([0-9]+)\s+([0-9]+)$")
    for x in example_data_1:
        res = pattern.`match`(x[])
        left.append(atol(str(res.group(1))))
        right.append(atol(str(res.group(2))))

    sort(left)
    sort(right)

    print("left")
    for i in left:
        print(i[])

    print("right")
    for j in right:
        print(j[])


    total_dist = 0
    print("recombined")
    for k in zipint(left, right):
        dist = abs(k[][0] - k[][1])
        total_dist += dist

    print(String("example 1 total: {}").format(total_dist))

    with open("input/day01.txt", 'r') as file:
        input_data = file.read()
        res = re.findall(r"^([0-9]+)\s+([0-9]+)$", input_data, re.MULTILINE)

        left = List[Int]()
        right = List[Int]()
        for x in res:
            left.append(atol(str(x[0])))
            right.append(atol(str(x[1])))
        
        sort(left)
        sort(right)

        total_dist = 0
        for k in zipint(left, right):
            dist = abs(k[][0] - k[][1])
            total_dist += dist

        print(String("part 1 total: {}").format(total_dist))

        sim_score = 0
        for y in left:
            count = right.count(y[])
            sim_score += y[] * count

        print(String("part 2 total: {}").format(sim_score))

