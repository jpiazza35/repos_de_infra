import os
import re

# def search_string(directory, search_term, datetime):
#     search_results = []
#     for root, dirs, files in os.walk(directory):
#         for file in files:
#             file_path = os.path.join(root, file)
#             with open(file_path, 'r') as f:
#                 for i, line in enumerate(f):
#                     if search_term in line:
#                         search_results.append((file_path, i+1, search_term))
#     return search_results

def search_terms(filepath, terms, rule, timestamp):
    report = {}
    for root, dirs, files in os.walk(filepath):
        for file in files:
            if file.endswith(".tf"):
                with open(os.path.join(root, file), "r") as f:
                    lines = f.readlines()
                    for i, line in enumerate(lines):
                        for term in terms:
                            if term in line:
                                filepath = os.path.join(root, file)
                                if filepath not in report:
                                    report[filepath] = []
                                report[filepath].append((i, line))
    write_to_report(report, rule, timestamp)
    return report

def search_accountid(filepath, rule, timestamp):
    report = {}
    for root, dirs, files in os.walk(filepath):
        for file in files:
            if file.endswith(".tf"):
                with open(os.path.join(root, file), "r") as f:
                    lines = f.readlines()
                    for i, line in enumerate(lines):
                        match = re.search(r"\d{12}", line)
                        if match:
                            filepath = os.path.join(root, file)
                            if filepath not in report:
                                report[filepath] = []
                            report[filepath].append((i, line))
    write_to_report(report, rule, timestamp)
    return report

def search_passwords(filepath, rule, timestamp):
    report = {}
    for root, dirs, files in os.walk(filepath):
        for file in files:
            if file.endswith(".tf") or file.endswith(".tfvars"):
                with open(os.path.join(root, file), "r") as f:
                    lines = f.readlines()
                    for i, line in enumerate(lines):
                        if re.search(r'password\s*=\s*"[\w!@]+"', line):
                            filepath = os.path.join(root, file)
                            if filepath not in report:
                                report[filepath] = []
                            report[filepath].append((i, line))
    write_to_report(report, rule, timestamp)
    return report

def search_open_iegress(filepath, rule, timestamp):
    report = {}
    for root, dirs, files in os.walk(filepath):
        for file in files:
            if file.endswith(".tf") or file.endswith(".tfvars"):
                with open(os.path.join(root, file), "r") as f:
                    lines = f.readlines()
                    for i, line in enumerate(lines):
                        if re.search(r'0.0.0.0', line):
                            filepath = os.path.join(root, file)
                            if filepath not in report:
                                report[filepath] = []
                            report[filepath].append((i, line))
    write_to_report(report, rule, timestamp)
    return report

def write_to_report(results, rule, timestamp):
    with open(f"{timestamp}-report.txt", "a") as f:
        if results:
            f.write(f"====================\n{rule}\n====================\n")
            print(f"====================\n{rule}\n====================\n")
            for file in results:
                f.write(file + ":\n")
                print(file)
                for result in results[file]:
                    print(f"Line " + str(result[0]) + ": " + result[1])
                    f.write("Line " + str(result[0]) + ": " + result[1])
        else:
            f.write(f"====================\n{rule}\n====================\n")
            f.write("0 findings")
            print(f"====================\n{rule}\n====================\n")
            print("0 findings")