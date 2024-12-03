from collections import InlineArray

fn is_safe(report: List[Int], depth: Int = 0) -> Bool:
    initial_direction = report[1] - report[0]
    for i in range(1, len(report)):
        diff = report[i] - report[i -1]
        abs_diff = abs(diff)
        equal_direction = abs(initial_direction + diff) == abs(initial_direction) + abs(diff)

        if (abs_diff >= 1 and abs_diff <= 3) and equal_direction:
            pass
        else:
            if depth == 0:
                for i in range(len(report)):
                    one_removed = report
                    _ = one_removed.pop(i)
                    # for y in one_removed:
                    #     print(y[], end=" ")
                    # print("")
                    if is_safe(one_removed, 1):
                        return True
            return False

    return True


fn main() raises:
    example_data_1 = List[String](
        "7 6 4 2 1",
        "1 2 7 8 9",
        "9 7 6 2 1",
        "1 3 2 4 5",
        "8 6 4 4 1",
        "1 3 6 7 9",
    )

    data = List[List[Int]]()
    for x in example_data_1:
        report = List[Int]()
        for y in x[].split(' '):
            report.append(atol(y[]))
        data.append(report)

    for y in data:
        for i in range(5):
            print(y[][i], end="")
        if is_safe(y[]):
            print(" Safe")
        else:
            print(" Unsafe")

    data = List[List[Int]]()
    with open("input/day02.txt", 'r') as file:
        input_data = file.read()
        reports = input_data.split('\n')
        for x in reports:
            report = List[Int]()
            for y in x[].split(' '):
                report.append(atol(y[]))
            data.append(report)

    safe_reports = 0
    for x in data:
        for y in x[]:
            print(y[], end=" ")
        if is_safe(x[], 1):
            print(" Safe")
            safe_reports += 1
        else:
            print(" Unsafe")

    print(String("part 1 total: {}").format(safe_reports))

    safe_reports_2 = 0
    for x in data:
        # for y in x[]:
        #     print(y[], end=" ")
        if is_safe(x[]):
            # print(" Safe")
            safe_reports_2 += 1
        # else:
        #     print(" Unsafe")

    print(String("part 2 total: {}").format(safe_reports_2))
